class CreateExchangeImpImgs < ActiveRecord::Migration[5.2]
  def change
    create_table :exchange_imp_imgs do |t|
      t.string :tag
      t.string :name
      t.binary :file, limit: 3.megabyte
      t.string :content_type 

      t.integer :exchange_id
    end
  end
end
