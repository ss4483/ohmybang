class PointHistory < ApplicationRecord
  belongs_to :user
  belongs_to :review, optional: true
  belongs_to :point, optional: true
  
  has_one :exchange
end
