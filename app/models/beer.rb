class Beer < ApplicationRecord
	belongs_to :brewery
	has_many :ratings

	def average_rating
		sum = ratings.sum { |r| r.score }
		return sum / ratings.count
	end
end
