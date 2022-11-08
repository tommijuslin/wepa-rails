require 'rails_helper'

describe "Beer" do
  before :each do
    FactoryBot.create :brewery
  end

  it "with a valid name is added to the system" do
    visit new_beer_path
    fill_in('beer_name', with: "Karhu")
    click_button('Create Beer')

    expect(page).to have_content "Beer was successfully created."
    expect(Beer.count).to eq(1)
  end

  it "without a valid name is not added to the system" do
    visit new_beer_path
    click_button('Create Beer')

    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end
