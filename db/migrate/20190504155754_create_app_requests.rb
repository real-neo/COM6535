class CreateAppRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :app_requests do |t|
      t.string :url
      t.boolean :open, default: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
