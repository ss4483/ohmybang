class Exchange < ApplicationRecord
  belongs_to :user
  belongs_to :point_history, optional: true
  has_many :exchange_imp_imgs
  has_many :exchange_confirms
end
