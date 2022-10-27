class User < ApplicationRecord
  include RatingAverage

  has_many :memberships
  has_many :ratings
  has_many :beers, through: :ratings
  has_many :clubs, through: :memberships, source: :beer_club

  validates :username, uniqueness: true,
                       length: { in: 3..30 }

  def to_s
    username.to_s
  end
end
