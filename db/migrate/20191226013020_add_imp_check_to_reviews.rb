class AddImpCheckToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :imp_check, :string, :default => "f"
  end
end
