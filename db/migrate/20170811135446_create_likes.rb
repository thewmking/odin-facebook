class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.timestamps
    end
    add_index :likes, [:user_id, :created_at]
    add_index :likes, [:post_id, :created_at]
  end
end
