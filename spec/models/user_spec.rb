require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end
  
  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved without a proper password" do
    user = User.create username: "Pekka", password: "Secret", password_confirmation: "Secret"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is saved with a proper password" do
    user = User.create username: "Pekka", password: "Secret1", password_confirmation: "Secret1"

    expect(user.valid?).to be(true)
    expect(User.count).to eq(1)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }
  
    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end
  
    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)
  
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({ user: user, brewery: "anonymous" }, 25)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user, brewery: "anonymous" }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user, brewery: "anonymous" }, 25)
    
      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({ user: user, style: "Lager", brewery: "anonymous" }, 25)

      expect(user.favorite_style.name).to eq(beer.style.name)
    end

    it "is the one with highest average rating if several rated" do
      create_beers_with_many_ratings({ user: user, brewery: "anonymous" }, 1, 40)
      create_beers_with_many_ratings({ user: user, brewery: "anonymous" }, 10)
      beer = create_beer_with_rating({ user: user, brewery: "anonymous" }, 39)

      expect(user.favorite_style.name).to eq(beer.style.name)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({ user: user, brewery: "anonymous" }, 25)

      expect(user.favorite_brewery).to eq(beer.brewery.name)
    end

    it "is the one with the highest average if several rated" do
      create_beers_with_many_ratings({ user: user, brewery: "brewery1" }, 10, 10, 10)
      create_beers_with_many_ratings({ user: user, brewery: "brewery2" }, 1, 1, 40)
      create_beers_with_many_ratings({ user: user, brewery: "brewery3" }, 20, 20, 39)

      expect(user.favorite_brewery).to eq("brewery3")
    end
  end
end
