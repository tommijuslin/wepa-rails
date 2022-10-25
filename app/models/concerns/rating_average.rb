module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
		sum = ratings.sum { |r| r.score }
		sum / ratings.count
	end
end