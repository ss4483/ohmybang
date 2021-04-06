class CreateSecViewers < ActiveRecord::Migration[5.2]
  def change
    create_table :sec_viewers do |t|
      t.string :viewer_type, default: "구매"

      t.string :receipt_url
      t.integer :item_type # 아이템 타입(1, 10, 30)
      t.integer :item_price
      t.integer :item_count # 구매 갯수 

      t.integer :price
      t.integer :count # 실제 갯수 (init: item_type * item_count)

      # t.string :order_id
      t.string :merchant_uid
      t.string :imp_uid

      t.date :exp_date

      t.integer :user_id
      t.timestamps
    end
  end
end
