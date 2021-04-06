require 'active_record/diff'
class Review < ApplicationRecord
  include ActiveRecord::Diff
  diff exclude: [:updated_at, :created_at, :status]

  has_one :edit_review, class_name: "Review", foreign_key: "original_id"
  belongs_to :original, class_name: "Review", optional: true

  belongs_to :user
  has_many :viewer_histories
  has_many :sec_viewer_histories
  has_many :review_items, :dependent => :delete_all
  has_many :review_videos, :dependent => :delete_all
  has_many :review_imgs, :dependent => :delete_all
  has_many :review_imp_imgs, :dependent => :delete_all
  has_many :point_histories
  has_many :review_confirms, :dependent => :delete_all

  has_many :recently_contracts, :dependent => :delete_all
  

  serialize :management_type
  serialize :style_nm
  serialize :suply_prvuse_ar
  serialize :suply_cmnuse_ar
  serialize :bass_rent_gtn
  serialize :bass_mt_rntchrg
  serialize :bass_cnvrs_gtn_lmt


  # validates :loan_1, inclusion: { in: ['t', 'f'] }
  # validates :is_recommend, inclusion: { in: ['t', 'f'] }

  # validates :is_check, inclusion: { in: ['t', 'f'] }
  validates :room, inclusion: { in: ["원룸", "투/쓰리룸", "오피스텔", "아파트"], allow_blank: true }
  validates :loan_1, inclusion: { in: ["t", "f"], allow_blank: true }
  validates :elevator, inclusion: { in: ["t", "f"], allow_blank: true }
  validates :balcony, inclusion: { in: ["t", "f"], allow_blank: true }
  validates :is_recommend, inclusion: { in: ["t", "f"], allow_blank: true }
  validates :contract_type, inclusion: { in: ["월세", "전세"], allow_blank: true }
  
  # validates :status, inclusion: { in: ['등록완료', '임시저장'] }

  acts_as_mappable default_units: :kms,
      default_formula: :sphere,
      distance_field_name: :distance,
      lat_column_name: :lat,
      lng_column_name: :long


  def self.daily_picks
    daily_pick_ids = Rails.cache.fetch('review_daily_picks', expires_in: 1.day.to_i) do
      self.where(status: "등록완료").pluck(:id).shuffle.first(6)
    end
    self.find(daily_pick_ids)
  end
end
