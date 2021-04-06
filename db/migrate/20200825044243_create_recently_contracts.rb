class CreateRecentlyContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :recently_contracts do |t|
      t.string :contract_type # 전월세구분
      t.float :suply_prvuse_ar # 전용면적

      t.date :compet_de # 계약년월일	ex) 20170807

      t.string :floor # 층수
      t.float :rent_gtn #	임대보증금(단위 : 만원) ex) 3470
      t.float  :mt_rntchrg # 월임대료(단위 : 만원) ex) 14

      t.integer :review_id
      # t.timestamps
    end
  end
end
