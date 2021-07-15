class CreatePostHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :post_hashtags do |t|
      t.integer :post_id, index: true, foreign_key: true
      t.integer :hashtag_id, index: true, foreign_key: true
      t.timestamps
    end
  end
end
