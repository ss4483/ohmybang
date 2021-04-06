class SecViewerHistory < ApplicationRecord
  belongs_to :user
  belongs_to :review, optional: true
  belongs_to :sec_viewer, optional: true
end
