class AddThirdPartyImpToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :third_party_imp, :string, default: "f"
  end
end
