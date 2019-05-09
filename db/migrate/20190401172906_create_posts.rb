class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :description
      t.integer :likes_count, default: 0
      t.integer :dislikes_count, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
