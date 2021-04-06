class CreateReqAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :req_addresses do |t|

      t.string :si_nm
      t.string :sgg_nm
      t.string :emd_nm
      t.timestamps
    end
  end
end
