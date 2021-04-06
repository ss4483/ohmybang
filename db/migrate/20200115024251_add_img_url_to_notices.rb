class AddImgUrlToNotices < ActiveRecord::Migration[5.2]
  def change
    add_column :notices, :img_url, :string
  end
end
