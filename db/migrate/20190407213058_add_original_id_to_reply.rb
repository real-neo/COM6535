class AddOriginalIdToReply < ActiveRecord::Migration[5.2]
  def change
    add_reference :replies, :original
  end
end
