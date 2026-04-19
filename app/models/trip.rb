class Trip < ApplicationRecord
  belongs_to :location
  belongs_to :user
  has_many :fishes, dependent: :destroy

  accepts_nested_attributes_for :fishes,
    allow_destroy: true,
    reject_if: proc { |attrs|
      attrs["name"].to_s.strip.blank?
    }

  accepts_nested_attributes_for :location,
    reject_if: proc { |attrs|
      attrs["id"].blank? &&
        attrs["name"].to_s.strip.blank? &&
        attrs["latitude"].to_s.strip.blank? &&
        attrs["longitude"].to_s.strip.blank?
    }

  validates :name, presence: true
  validates :location, presence: true
  before_validation :ensure_location_user

  private

  def ensure_location_user
    return unless location && user_id

    location.user_id ||= user_id
  end
end
