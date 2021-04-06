class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # has_many :users_viewer_histroies
  # has_many :viewer_histroies, through: :users_viewer_histroies
  
  serialize :histories
  
  has_many :viewer_histories
  has_many :sec_viewer_histories
  has_many :point_histories
  has_many :reviews
  has_many :viewers
  has_many :sec_viewers
  has_many :points

  has_many :owner_comments

  has_many :exchanges
end
 