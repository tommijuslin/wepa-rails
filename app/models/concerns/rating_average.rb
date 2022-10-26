module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    sum = ratings.sum(&:score)
    sum / ratings.count
  end
end
