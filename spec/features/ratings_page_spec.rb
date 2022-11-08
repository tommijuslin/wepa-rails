require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "page lists the ratings and their total number" do
    rating1 = FactoryBot.create(:rating, score: 10, user: user)
    rating2 = FactoryBot.create(:rating, score: 15, user: user)
    visit ratings_path

    expect(page).to have_content "Number of ratings: #{Rating.count}"
    expect(page).to have_content "#{rating1.beer.name} #{rating1.score} #{rating1.user.username}"
    expect(page).to have_content "#{rating2.beer.name} #{rating2.score} #{rating2.user.username}"
  end
end