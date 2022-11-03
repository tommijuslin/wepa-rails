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
    return nil if ratings.empty?

    scores = ratings.group_by { |r| r.beer.style }
                    .transform_values { |v| v.sum(&:score) / v.count.to_f }

    scores.max_by(&:last).first
  end

  def favorite_brewery
    return nil if ratings.empty?

    scores = ratings.group_by { |r| r.beer.brewery.name }
                    .transform_values { |v| v.sum(&:score) / v.count.to_f }

    scores.max_by(&:last).first
  end
end
