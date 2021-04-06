class Viewer < ApplicationRecord
  belongs_to :user
  has_many :viewer_histories
  # has_one :viewer_history
end
