class ReqComment < ApplicationRecord
  belongs_to :req_address
  has_secure_password # 비밀번호에 대한 유효성검사 자동으로 함
  validates :password, presence: true, length: {is: 6}
end
