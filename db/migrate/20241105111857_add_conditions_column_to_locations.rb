class AddConditionsColumnToLocations < ActiveRecord::Migration[7.2]
  def change
    add_column :locations, :conditions, :integer, default: 0
  end
end
