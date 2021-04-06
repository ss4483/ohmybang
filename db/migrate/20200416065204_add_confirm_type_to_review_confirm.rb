class AddConfirmTypeToReviewConfirm < ActiveRecord::Migration[5.2]
  def change
    add_column :review_confirms, :confirm_type, :string
    ReviewConfirm.all.each do |review_confirm|
      review_confirm.update_attributes(confirm_type: '리뷰')
    end
  end
end
