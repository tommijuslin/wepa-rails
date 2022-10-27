class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :beer_club

  def to_s
    beer_club.name.to_s
  end
end
