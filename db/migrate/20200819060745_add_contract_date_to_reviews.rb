class AddContractDateToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :contract_date, :date # 계약 일자
  end
end
