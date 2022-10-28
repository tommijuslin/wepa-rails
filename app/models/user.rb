class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  has_many :memberships
  has_many :ratings
  has_many :beers, through: :ratings
  has_many :clubs, through: :memberships, source: :beer_club

  validates :username, uniqueness: true,
                       length: { in: 3..30 }

  validates :password, length: { minimum: 4 },
                       format: { with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{4,}\z/,
                         message: "password must contain at least one number and one uppercase letter" }

  def to_s
    username.to_s
  end
end
