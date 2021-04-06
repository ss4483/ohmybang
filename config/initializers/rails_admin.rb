RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
    redirect_to main_app.root_path unless current_user.role === "manager"
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  
  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
  

  config.model 'ReviewConfirm' do
    label "[리뷰] 확인" 
    label_plural "[리뷰] 확인"
  end

  config.model 'Review' do
    label "[리뷰]" 
    label_plural "[리뷰]"
    list do 
      field :id	
      field :user
      field :status
      field :imp_status
      field :deposit
      field :monthly
      field :contract_type
      field :editable	
      field :created_at	
      field :lat
      field :long	
      field :address	
      field :detail_address	
      field :extra_address	
      field :bd_nm	
      field :si_nm
      field :sgg_nm	
      field :emd_nm	
      field :room	
      field :start_year	
      field :end_year	
      field :floor
      field :loan_1	
      field :pet	
      field :is_recommend	
      field :hourly_seasonal_txt
      field :short_comment	
      field :long_comment
      field :original	
      field :updated_at	
      field :main_img_name	
      field :main_img_content_type		
      field :edit_review
      field :viewer_histories	
      field :review_items	
      field :review_videos
      field :review_imgs
      field :review_imp_imgs
      field :point_histories
      field :review_confirms
    end 
    fields_of_type :date do
      strftime_format "%Y-%m-%d"
    end
  end
  
  
  config.model 'ReviewItem' do
    label "[리뷰] 항목" 
    label_plural "[리뷰] 항목"
  end
  config.model 'ReviewVideo' do
    label "[리뷰] 일반 영상" 
    label_plural "[리뷰] 일반 영상"
  end
  config.model 'ReviewImg' do
    label "[리뷰] 일반 이미지" 
    label_plural "[리뷰] 일반 이미지"
  end

  config.model 'ReviewImpImg' do
    label "[리뷰] 증빙 이미지" 
    label_plural "[리뷰] 증빙 이미지"
  end

  config.model 'Notice' do
    label "공지사항" 
    label_plural "공지사항"
    fields_of_type :date do
      strftime_format "%Y-%m-%d"
    end
  end

  config.model 'OwnerComment' do
    label "[임대인 코멘트]" 
    label_plural "[임대인 코멘트]"
    fields_of_type :date do
      strftime_format "%Y-%m-%d"
    end
  end
  config.model 'OwnerCommentImg' do
    label "[임대인 코멘트] 이미지" 
    label_plural "[임대인 코멘트] 이미지"
  end
  config.model 'OwnerCommentImpImg' do
    label "[임대인 코멘트] 증빙 이미지" 
    label_plural "[임대인 코멘트] 증빙 이미지"
  end
  config.model 'OwnerCommentConfirm' do
    label "[임대인 코멘트] 확인" 
    label_plural "[임대인 코멘트] 확인"
  end
  config.model 'Exchange' do
    label "[환전] 내역" 
    label_plural "[환전] 내역"
  end
  config.model 'ExchangeImpImg' do
    label "[환전] 증빙 이미지"
    label_plural "[환전] 증빙 이미지"
  end
  config.model 'ExchangeConfirm' do
    label "[환전] 확인"
    label_plural "[환전] 확인"
  end
  

  config.model 'Point' do
    label "[포인트]" 
    label_plural "[포인트]"
    fields_of_type :date do
      strftime_format "%Y-%m-%d"
    end
  end
  config.model 'PointHistory' do
    label "[포인트] 내역" 
    label_plural "[포인트] 내역"
  end
  config.model 'Viewer' do
    label "[리뷰 이용권] 구매 내역" 
    label_plural "[리뷰 이용권] 구매 내역"
    fields_of_type :date do
      strftime_format "%Y-%m-%d"
    end
  end
  config.model 'ViewerHistory' do
    label "[리뷰 이용권] 사용 내역" 
    label_plural "[리뷰 이용권] 사용 내역"
  end

  config.model 'SecViewer' do
    label "[전/월세금 이용권] 구매 내역" 
    label_plural "[전/월세금 이용권] 구매 내역"
    fields_of_type :date do
      strftime_format "%Y-%m-%d"
    end
  end
  config.model 'SecViewerHistory' do
    label "[전/월세금 이용권] 사용 내역" 
    label_plural "[전/월세금 이용권] 사용 내역"
  end
  config.model 'User' do
    label "User" 
    label_plural "User"
    list do 
      field :id	
      field :email	
      field :created_at
      field :updated_at	
      field :name
      field :merchant_uid
      field :imp_uid
    end
  end
end

# RailsAdmin.config.actions do |action|
#   action.show_in_app 'ReviewImg' do 

#   end
# end