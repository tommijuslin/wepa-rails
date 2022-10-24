class Beer < ApplicationRecord
    belongs_to :brewery
    has_many :ratings

    def average_rating
        total = 0
        ratings.each { |rating| total += rating.score }
        return total / ratings.count
    end
end
