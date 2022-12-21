class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  has_many :memberships, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :clubs, through: :memberships, source: :beer_club

  validates :username, uniqueness: true,
                       length: { in: 3..30 }

  validates :password, length: { minimum: 4 },
                       format: { with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*\z/,
                                 message: "password must contain at least one number and one uppercase letter" }

  def to_s
    username.to_s
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite(:style)
  end

  def favorite_brewery
    favorite(:brewery)
  end

  def favorite(grouped_by)
    return nil if ratings.empty?

    grouped_ratings = ratings.group_by{ |r| r.beer.send(grouped_by) }
    averages = grouped_ratings.map do |group, ratings|
      { group:, score: average_of(ratings) }
    end

    averages.max_by{ |r| r[:score] }[:group]
  end

  def average_of(ratings)
    ratings.sum(&:score).to_f / ratings.count
  end

  def self.top(number)
    sorted_by_rating_count_in_desc_order = User.all.sort_by { |u| u.ratings.count }.reverse!
    sorted_by_rating_count_in_desc_order.take(number)
  end
end
