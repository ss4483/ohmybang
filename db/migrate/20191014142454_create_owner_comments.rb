class CreateOwnerComments < ActiveRecord::Migration[5.2]
  def change
    create_table :owner_comments do |t|

      t.string :status

      t.decimal :lat, {:precision=>10, :scale=>6}
      t.decimal :long, {:precision=>10, :scale=>6}
            
      t.string :address
      t.string :detail_address
      t.string :extra_address
      t.string :bd_nm
      t.string :si_nm
      t.string :sgg_nm
      t.string :emd_nm

      t.string :room

      # 몰래카메라 탐지 여부 
      t.string :hidden_camera
      # 연락 시간
      t.string :contact_time
      # 연락 방법
      t.string :contact_method, default: [].to_yaml
      # 장기계약 이점
      t.text :long_term_txt
      # 최근 리모델링 (리모델링, 수리, 교체 등) 날짜 (전 후 사진) - 기간 (2년 이내)
      t.date :remodeling_date
      t.text :remodeling_txt
      # 소개 및 자랑
      t.text :intro_txt


      t.integer :user_id 
      t.integer :original_id
      t.timestamps
    end
  end
end
