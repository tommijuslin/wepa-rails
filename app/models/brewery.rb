class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { only_integer: true,
                                   greater_than_or_equal_to: 1040 }

  validate :year_greater_than_current_year

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def year_greater_than_current_year
    return unless year > Date.current.year

    errors.add(:year, "must be less than or equal to #{Date.current.year}")
  end

  def print_report
    puts name
    puts "established in year #{year}"
    puts "number of beers #{beers.count}"
  end

  def self.top(number)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by(&:average_rating).reverse
    sorted_by_rating_in_desc_order.take(number)
  end
end
