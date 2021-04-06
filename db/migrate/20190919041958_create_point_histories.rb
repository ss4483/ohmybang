class CreatePointHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :point_histories do |t|
      t.integer :pt
      t.string :memo 

      t.integer :review_id
      t.integer :user_id
      t.integer :point_id
      t.integer :exchange_id
      t.timestamps
    end
  end
end
