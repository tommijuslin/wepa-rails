require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
    FactoryBot.create :brewery
    FactoryBot.create :style
  end

  it "with a valid name is added to the system" do
    visit new_beer_path
    fill_in('beer_name', with: "Karhu")
    click_button('Create beer')

    expect(page).to have_content "Beer was successfully created."
    expect(Beer.count).to eq(1)
  end

  it "without a valid name is not added to the system" do
    visit new_beer_path
    click_button('Create beer')

    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end
