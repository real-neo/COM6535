class CreateCreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :create_polls do |t|

      t.timestamps
    end
  end
end
