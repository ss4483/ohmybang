class AddFreeToViewer < ActiveRecord::Migration[5.2]
  def change
    add_column :viewers, :free, :string
    add_column :sec_viewers, :free, :string
  end
end
