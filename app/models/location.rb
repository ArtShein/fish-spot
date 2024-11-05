class Location < ApplicationRecord
  belongs_to :user
  has_many :trips

  enum accessibility: {
    not_paid: 0,
    paid: 1
  }

  enum conditions: {
    good: 0,
    medium: 1,
    bad: 2
  }

  enum proximity: {
    near: 0,
    far: 1
  }

  validates :name, presence: true
end
