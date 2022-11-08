require 'rails_helper'

include Helpers

describe "User" do
  let!(:user) { FactoryBot.create :user }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "page shows the user's own ratings" do
    rating = FactoryBot.create(:rating, score: 10, user: user)
    FactoryBot.create(:rating, score: 10, user: user)
    other_user = FactoryBot.create(:user, username: "Matti")
    other_rating = FactoryBot.create(:rating, score: 15, user: other_user)
    visit user_path(user)
    
    expect(page).to have_content "Has made #{user.ratings.count} rating"
    expect(page).to have_content "#{rating.beer.name} #{rating.score}"
    expect(page).not_to have_content "#{other_rating.beer.name} #{other_rating.score}"
  end
end