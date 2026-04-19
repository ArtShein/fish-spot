# frozen_string_literal: true

class AddTripIdToFish < ActiveRecord::Migration[7.2]
  def change
    add_reference :fish, :trip, foreign_key: true
  end
end
