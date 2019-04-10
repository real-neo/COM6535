class RemoveLikesDislikesFromPost < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :likes, :integer
    remove_column :posts, :dislikes
  end
end
