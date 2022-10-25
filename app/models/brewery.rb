class Brewery < ApplicationRecord
	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers

	def print_report
		puts name
		puts "established in year #{year}"
		puts "number of beers #{beers.count}"
	end

	def average_rating
		sum = ratings.sum { |r| r.score }
		sum / ratings.count
	end
end
