class Notice < ApplicationRecord
  has_many :winners, class_name: "Notice", foreign_key: "event_id"
  belongs_to :event, class_name: "Notice", optional: true
end
