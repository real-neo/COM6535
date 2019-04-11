class AddPostTypeToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :post_type, :integer
  end
end
