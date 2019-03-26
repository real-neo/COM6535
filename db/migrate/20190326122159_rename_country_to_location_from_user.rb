class RenameCountryToLocationFromUser < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :country, :location
  end
end
