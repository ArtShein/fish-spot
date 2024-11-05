class CreateFish < ActiveRecord::Migration[7.2]
  def change
    create_table :fish do |t|
      t.string :name
      t.integer :quantity
      t.integer :type
      t.float :weight

      t.timestamps
    end
  end
end
