require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "with a proper brewery" do
    let(:test_brewery) { Brewery.new name: "Koff", year: 1897 }

    it "is saved with a proper name, style and brewery" do
      beer = Beer.create name: "Karhu", style: "Lager", brewery: test_brewery
      
      expect(beer.valid?).to be(true)
      expect(Beer.count).to eq(1)
    end
    
    it "is not saved without a name" do
      beer = Beer.create style: "Lager", brewery: test_brewery

      expect(beer.valid?).to be(false)
      expect(Beer.count).to eq(0)
    end

    it "is not saved without a style" do
      beer = Beer.create name: "Karhu", brewery: test_brewery

      expect(beer.valid?).to be(false)
      expect(Beer.count).to eq(0)
    end
  end
end
