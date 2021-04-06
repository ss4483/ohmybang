class AddColumnsToNotice < ActiveRecord::Migration[5.2]
  def change
    add_column :notices, :post_type, :string
    add_column :notices, :start_date, :date
    add_column :notices, :end_date, :date
  end
end
