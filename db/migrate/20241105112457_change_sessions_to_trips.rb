class ChangeSessionsToTrips < ActiveRecord::Migration[7.2]
  def change
    rename_table :sessions, :trips
  end
end
