# frozen_string_literal: true

class AddCoordinatesToTrips < ActiveRecord::Migration[7.2]
  def change
    add_column :trips, :latitude, :decimal, precision: 10, scale: 7
    add_column :trips, :longitude, :decimal, precision: 10, scale: 7
  end
end
