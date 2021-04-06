class AddRentalHouseToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :is_rental_house, :string, default: "f"

    add_column :reviews, :instt_nm, :string # 기관 명 ex) SH공사
    add_column :reviews, :compet_de, :date # 준공 일자	ex) 20170807
    add_column :reviews, :hshld_co, :integer # 세대 수	ex) 192
    add_column :reviews, :suply_ty_nm, :string # 공급 유형 명 ex) 50년임대
    add_column :reviews, :house_ty_nm, :string # 주택 유형 명 ex) 아파트
    add_column :reviews, :heat_mthd_detail_nm, :string # 난방 방식	 ex) 개별난방
    add_column :reviews, :buld_stle_nm, :string  # 건물 형태 ex) 복도식
    add_column :reviews, :elvtr_instl_at_nm, :string # 승강기 설치여부	ex) 전체동 설치
    add_column :reviews, :parkng_co, :integer # 주차수 ex) 183
    
    add_column :reviews, :style_nm, :float # 형 명	ex) 39.9541	
    add_column :reviews, :suply_prvuse_ar, :float # 공급 전용 면적 (단위 : ㎡) ex) 39.9541
    add_column :reviews, :suply_cmnuse_ar, :float  #	공급 전용 면적 (단위 : ㎡) ex) 21.7274
    add_column :reviews, :bass_rent_gtn, :integer #	기본 임대보증금(단위 : 원) ex) 34700000
    add_column :reviews, :bass_mt_rntchrg, :integer # 기본 월임대료(단위 : 원) ex) 149500
    add_column :reviews, :bass_cnvrs_gtn_lmt, :integer # 기본 전환보증금(단위 : 원) ex) 0
  end
end
