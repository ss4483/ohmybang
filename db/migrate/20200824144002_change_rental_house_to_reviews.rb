class ChangeRentalHouseToReviews < ActiveRecord::Migration[5.2]
  def change
    change_table :reviews do |table|
      table.change :style_nm, :string, default: [].to_yaml # 형 명	ex) 39.9541	
      table.change :suply_prvuse_ar, :string, default: [].to_yaml # 공급 전용 면적 (단위 : ㎡) ex) 39.9541
      table.change :suply_cmnuse_ar, :string, default: [].to_yaml  #	공급 전용 면적 (단위 : ㎡) ex) 21.7274
      table.change :bass_rent_gtn, :string, default: [].to_yaml #	기본 임대보증금(단위 : 원) ex) 34700000
      table.change :bass_mt_rntchrg, :string, default: [].to_yaml # 기본 월임대료(단위 : 원) ex) 149500
      table.change :bass_cnvrs_gtn_lmt, :string, default: [].to_yaml # 기본 전환보증금(단위 : 원) ex) 0
    end
    # add_column :reviews, :style_nm, :float
    # add_column :reviews, :suply_prvuse_ar, :float
    # add_column :reviews, :suply_cmnuse_ar, :float
    # add_column :reviews, :bass_rent_gtn, :integer
    # add_column :reviews, :bass_mt_rntchrg, :integer
    # add_column :reviews, :bass_cnvrs_gtn_lmt, :integer

    # add_column :reviews, :deposit, :integer, default: 0 # 전세(만원)
    # add_column :reviews, :monthly, :integer, default: 0 # 월세(만원)

    # add_column :reviews, :area_pyeong, :float, default: "" # 평수
    # add_column :reviews, :area_square, :float, default: "" # m^2
  end
end
