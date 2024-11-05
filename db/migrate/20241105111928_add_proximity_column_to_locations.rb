class AddProximityColumnToLocations < ActiveRecord::Migration[7.2]
  def change
    add_column :locations, :proximity, :integer, default: 0
  end
end
