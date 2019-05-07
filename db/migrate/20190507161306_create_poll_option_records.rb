class CreatePollOptionRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :poll_option_records do |t|
      t.references :user, foreign_key: true
      t.references :poll_option, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
