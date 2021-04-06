class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :editable, null: false, default: "t"

      t.string :main_img_name
      t.binary :main_img, limit: 3.megabyte
      t.string :main_img_content_type

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

      t.integer :start_year
      t.integer :end_year

      t.string :floor
      t.string :loan_1
      t.string :pet

      t.string :is_recommend

      t.text :hourly_seasonal_txt

      t.string :short_comment
      t.text :long_comment

      t.integer :user_id # user
      t.integer :original_id
      t.timestamps
    end
  end
end