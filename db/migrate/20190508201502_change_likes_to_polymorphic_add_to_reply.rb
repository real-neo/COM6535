class ChangeLikesToPolymorphicAddToReply < ActiveRecord::Migration[5.2]
  def change

    remove_reference(:likes, :post_id, index: true, foreign_key: true)
    add_reference :likes, :likeable, polymorphic: true, index: true

  end
end
