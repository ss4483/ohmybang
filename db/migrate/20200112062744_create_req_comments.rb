class CreateReqComments < ActiveRecord::Migration[5.2]
  def change
    create_table :req_comments do |t|
      t.text :content
      t.string :address
      t.string :password_digest
      
      t.string :client_ip
      
      t.integer :req_address_id
      t.timestamps
    end
  end
end
