class ViewerHistory < ApplicationRecord
  belongs_to :user
  belongs_to :review, optional: true
  belongs_to :viewer, optional: true
end
