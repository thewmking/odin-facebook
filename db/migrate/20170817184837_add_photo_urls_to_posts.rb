class AddPhotoUrlsToPosts < ActiveRecord::Migration[5.0]
  def change
    change_table :posts do |t|
      t.text :photo_url
    end
  end
end
