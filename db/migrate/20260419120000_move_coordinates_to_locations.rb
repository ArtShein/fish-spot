# frozen_string_literal: true

class MoveCoordinatesToLocations < ActiveRecord::Migration[7.2]
  def up
    add_column :locations, :latitude, :decimal, precision: 10, scale: 7
    add_column :locations, :longitude, :decimal, precision: 10, scale: 7

    Trip.reset_column_information
    Location.reset_column_information

    Trip.where.not(latitude: nil).find_each do |trip|
      next if trip.longitude.blank?

      loc = Location.find_by(id: trip.location_id)
      next unless loc

      if loc.latitude.blank? && loc.longitude.blank?
        loc.update_columns(latitude: trip.latitude, longitude: trip.longitude)
      end
    end

    remove_column :trips, :latitude, :decimal
    remove_column :trips, :longitude, :decimal
  end

  def down
    add_column :trips, :latitude, :decimal, precision: 10, scale: 7
    add_column :trips, :longitude, :decimal, precision: 10, scale: 7

    Trip.reset_column_information
    Location.reset_column_information

    Trip.find_each do |trip|
      loc = trip.location
      next unless loc&.latitude.present? && loc.longitude.present?

      trip.update_columns(latitude: loc.latitude, longitude: loc.longitude)
    end

    remove_column :locations, :latitude, :decimal
    remove_column :locations, :longitude, :decimal
  end
end
