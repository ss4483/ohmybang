class CreateSecViewerHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :sec_viewer_histories do |t|

      t.integer :viewer_count

      t.string :memo
      t.datetime :date_of_use

      t.integer :user_id
      t.integer :review_id
      t.integer :sec_viewer_id

      t.timestamps
    end
  end
end
