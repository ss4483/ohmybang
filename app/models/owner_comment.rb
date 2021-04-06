class OwnerComment < ApplicationRecord
  has_one :edit_owner_comment, class_name: "OwnerComment", foreign_key: "original_id"
  belongs_to :original, class_name: "OwnerComment", optional: true

  belongs_to :user
  has_many :owner_comment_imgs, :dependent => :delete_all
  has_many :owner_comment_imp_imgs, :dependent => :delete_all
  has_many :owner_comment_confirms, :dependent => :delete_all

  serialize :contact_method
end
