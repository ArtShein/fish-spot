class Location < ApplicationRecord
  belongs_to :user
  has_many :trips

  enum accessibility: {
    free: 0,
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

  scope :with_coordinates, -> { where.not(latitude: nil).where.not(longitude: nil) }

  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, allow_nil: true
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_nil: true
  validate :coordinates_pair
  validate :coordinates_or_title

  before_validation :normalize_coordinates
  before_validation :assign_default_name_from_coordinates

  def coordinates?
    latitude.present? && longitude.present?
  end

  def display_name
    name.presence || (coordinates? ? "#{latitude.to_f.round(4)}, #{longitude.to_f.round(4)}" : "—")
  end

  private

  def coordinates_or_title
    return if coordinates?
    return if name.present?

    errors.add(:base, :need_map_or_name)
  end

  def coordinates_pair
    return if latitude.blank? && longitude.blank?

    errors.add(:latitude, :incomplete_pair) if latitude.blank?
    errors.add(:longitude, :incomplete_pair) if longitude.blank?
  end

  def normalize_coordinates
    %i[latitude longitude].each do |attr|
      val = self[attr]
      self[attr] = nil if val.is_a?(String) && val.strip.empty?
    end
  end

  def assign_default_name_from_coordinates
    return if name.present?
    return unless coordinates?

    self.name = "#{latitude.to_f.round(4)}, #{longitude.to_f.round(4)}"
  end
end
