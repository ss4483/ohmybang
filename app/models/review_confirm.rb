class ReviewConfirm < ApplicationRecord
  belongs_to :review

  validates :confirm_type, inclusion: { in: ["증빙", "리뷰"] }
end

