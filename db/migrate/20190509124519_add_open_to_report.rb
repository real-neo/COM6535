class AddOpenToReport < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :open, :boolean, default: true
  end
end
