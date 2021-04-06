class CreateViewers < ActiveRecord::Migration[5.2]
  def change
    create_table :viewers do |t|
      t.string :viewer_type, default: "구매"

      t.string :receipt_url
      t.integer :item_type
      t.integer :item_price
      t.integer :item_count

      t.integer :price
      t.integer :count

      # t.string :order_id
      t.string :merchant_uid
      t.string :imp_uid

      t.date :exp_date

      t.integer :user_id
      t.timestamps
    end
  end
end
