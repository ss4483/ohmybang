class CreateReviewItems < ActiveRecord::Migration[5.2]
  def change
    create_table :review_items do |t|
      t.string :tag
      t.integer :score
      t.text :comment

      t.integer :review_id 
    end
  end
end
