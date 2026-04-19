# frozen_string_literal: true

class RenameTypeToKindOnFish < ActiveRecord::Migration[7.2]
  def change
    rename_column :fish, :type, :kind
  end
end
