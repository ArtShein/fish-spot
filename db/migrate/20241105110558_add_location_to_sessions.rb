class AddLocationToSessions < ActiveRecord::Migration[7.2]
  def change
    add_reference :sessions, :location, null: false, foreign_key: true
  end
end
