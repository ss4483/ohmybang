require 'active_record/diff'
class ReviewVideo < ApplicationRecord
  include ActiveRecord::Diff
  belongs_to :review
  belongs_to :review_item
  
  validates :tag, inclusion: { 
    in: ["채광","환기/냄새","벌레","파손","방음","누수","외풍","곰팡이","수압","수온","배수","치안상태","분리수거","주차장","응대","수리 및 보완","혜택","보증금 반환 만족도"]
  }
end
