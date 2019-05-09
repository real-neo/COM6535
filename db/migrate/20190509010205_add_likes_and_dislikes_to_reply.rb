class AddLikesAndDislikesToReply < ActiveRecord::Migration[5.2]
  def change
    add_column :replies, :likes_count, :integer, default: 0
    add_column :replies, :dislikes_count, :integer, default: 0
  end
end
