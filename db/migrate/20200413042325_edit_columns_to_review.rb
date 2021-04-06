class EditColumnsToReview < ActiveRecord::Migration[5.2]
  def change
    remove_column :reviews, :imp_check, :string
    add_column :reviews, :imp_status, :string, default: "완료"
    add_column :reviews, :deposit, :integer, default: 0 # 전세(만원)
    add_column :reviews, :monthly, :integer, default: 0 # 월세(만원)
    add_column :reviews, :contract_type, :string, default: "" # 전세/월세

    add_column :reviews, :management_fee, :integer, default: "" # -1 : 관리비 없음 / 0이상 : 관리비 있음
    add_column :reviews, :management_type, :string, default: [].to_yaml
    add_column :reviews, :parking, :integer, default: -1 # -1 : 주차 안됨 / 0이상 : 주차 됨

    add_column :reviews, :area_pyeong, :float, default: "" # 평수
    add_column :reviews, :area_square, :float, default: "" # m^2
    add_column :reviews, :structure, :string, default: "" # 구조 : 철근콘크리트
    add_column :reviews, :usage, :string, default: "" # 용도 : 가정집
    add_column :reviews, :floor_detail, :string, default: "" # 층수

    add_column :reviews, :start_date, :date # 임대차 기간
    add_column :reviews, :end_date, :date # 임대차 기간

    add_column :reviews, :elevator, :string # 엘리베이터
    add_column :reviews, :balcony, :string # 베란다/발코니
  end
end
