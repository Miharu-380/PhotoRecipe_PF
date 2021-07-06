class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.text :title
      t.string :image_id, null: false
      t.string :photo_app, null: false
      t.string :photo_filter
      t.string :fix_app
      t.string :fix_filter
      t.string :exposure
      t.string :highlight
      t.string :burilliance
      t.string :shadow
      t.string :contrast
      t.string :brightness
      t.string :saturation
      t.string :warmth
      t.string :sharpness
      t.text :body
      t.timestamps
    end
    add_index :posts, :user_id
    add_index :posts, :image_id
    add_index :posts, :photo_app
  end
end
