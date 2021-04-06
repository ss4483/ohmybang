class CreateExchangeConfirms < ActiveRecord::Migration[5.2]
  def change
    create_table :exchange_confirms do |t|
      t.text :memo
      t.string :status

      t.integer :exchange_id # user
      t.timestamps
    end
  end
end
