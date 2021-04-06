class SecViewer < ApplicationRecord
  belongs_to :user
  has_many :sec_viewer_histories
end
