class CreateReviewConfirms < ActiveRecord::Migration[5.2]
  def change
    create_table :review_confirms do |t|
      t.text :memo
      t.string :status
      
      t.integer :review_id # user
      t.timestamps
    end
  end
end
