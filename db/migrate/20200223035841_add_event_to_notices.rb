class AddEventToNotices < ActiveRecord::Migration[5.2]
  def change
    add_column :notices, :event_id, :integer
  end
end
