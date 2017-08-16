class AddAcceptedToFriendships < ActiveRecord::Migration[5.0]
  def change
    change_table :friendships do |t|
      t.boolean :accepted, default: false
    end
  end
end
