class CreateExchanges < ActiveRecord::Migration[5.2]
  def change
    create_table :exchanges do |t|
      t.string :status
        
      t.integer :pt # 포인트
      t.integer :actual_money # 환전액
      
      t.string :phone

      t.string :account_holder # 예금주
      t.string :bank  # 은행
      t.string :account_number # 계좌번호
      

      t.integer :user_id
      t.integer :point_history_id
      t.timestamps
    end
  end
end
