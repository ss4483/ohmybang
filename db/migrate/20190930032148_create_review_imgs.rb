class CreateReviewImgs < ActiveRecord::Migration[5.2]
  def change
    create_table :review_imgs do |t|
      t.string :tag
      t.string :name
      t.binary :file, limit: 3.megabyte
      t.string :content_type


      t.integer :review_item_id 
      t.integer :review_id 
    end
  end
end
