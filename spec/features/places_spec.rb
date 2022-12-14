require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new( name: "Oljenkorsi", id: 1 )]
    )
    allow(WeatherstackApi).to receive(:weather_in).with("kumpula").and_return(nil)

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, all are shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [
        Place.new( name: "Oljenkorsi", id: 1 ),
        Place.new( name: "Koljenorsi", id: 2 ),
        Place.new( name: "Räkälä", id: 3 )
      ]
    )
    allow(WeatherstackApi).to receive(:weather_in).with("kumpula").and_return(nil)

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Koljenorsi"
    expect(page).to have_content "Räkälä"
  end

  it "if none are returned by the AP, show appropriate message" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([])

    visit places_path
    fill_in('city', with: "kumpula")
    click_button "Search"

    expect(page).to have_content "No locations in kumpula"
  end
end
