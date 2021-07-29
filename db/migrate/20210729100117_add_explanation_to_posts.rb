class AddExplanationToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :explanation, :text
  end
end
