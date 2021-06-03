Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root "statics#index_3"

  get '/intro', to: "statics#intro"
  
  # 이미지
  get 'images/:model/:name', to: "application#images"
  get 'videos/:model/:name', to: "application#videos"
  get 'imp_images/:model/:name', to: "application#imp_images"
  get 'upload_videos/:model/:name', to: "application#upload_videos"

  # 뷰어 구매
  get '/viewers/new', to: "viewers#new"
  post '/viewers/create', to: "viewers#create"
  delete '/viewers/:id', to: "viewers#delete"
  get 'mobile_viewers', to: "viewers#payment_mobile"

  get '/viewers', to: "viewers#index"
  post 'viewers/:id', to: "viewers#use"
  post 'sec_viewers/:id', to: "sec_viewers#use"
  delete 'sec_viewers/:id', to: "sec_viewers#delete"


  # 리뷰 
  get '/sample', to: "reviews#sample"
  get '/reviews/manual', to: "reviews#manual"
  
  # resources :reviews 
  get 'reviews', to: "reviews#index"
  get 'reviews/new', to: "reviews#new"
  post 'reviews', to: "reviews#create"
  get 'reviews/:id/edit', to: "reviews#edit"
  get 'reviews/:id', to: "reviews#show", as: "review"
  put 'reviews/:id', to: "reviews#update"
  patch 'reviews/:id', to: "reviews#update"
  get 'reviews/:id/review', to: "reviews#edit_review"
  put 'reviews/:id/review', to: "reviews#update_review"
  patch 'reviews/:id/review', to: "reviews#update_review"

  # 리뷰 수정
  get 'reviews/:id/retouch', to: "reviews#retouch_show"
  put 'reviews/:id/retouch', to: "reviews#retouch_review"
  patch 'reviews/:id/retouch', to: "reviews#retouch_review"


  # ReviewList
  get 'reviewLists', to: "review_lists#index"
  # ReviewRequest
  get 'reqReviews', to: "req_reviews#index"
  post 'reqReviews', to: "req_reviews#create"
  delete 'reqReviews/:id', to: "req_reviews#delete"
  # get 'search_si', to: "req_reviews#search_si"
  get 'search_sgg', to: "req_reviews#search_sgg"
  get 'search_emd', to: "req_reviews#search_emd"
  
  # 환전
  resources :exchanges, only: ["create", "new", "edit", "update"]
  post 'certifications/confirm', to: 'exchanges#certifications'

  # 집주인 코멘트
  get '/owner_comments/:id/edit_content', to: "owner_comments#edit_content"
  resources :owner_comments, only: ["show", "create", "new", "edit", "update"]
  post '/check_address', to: "owner_comments#check_address"
  # post 'ownercomments', to: "owner_comments#create"
  # get 'ownercomments/new', to: "owner_comments#new"
  # get 'ownercomments/:id/edit', to: "owner_comments#edit"
  # patch 'ownercomments/:id', to: "owner_comments#update"

  # 공지사항
  get 'notices', to: 'notices#index'

  # 마이페이지
  get 'mypage/reviews', to: "mypage#reviews"
  get 'mypage/viewers', to: "mypage#viewers"
  get "mypage/owner_comments", to: "mypage#owner_comments"


  post 'search', to: "reviews#search"
  post 'checkRentalHouse/:id', to: "reviews#check_rental_house"
  

  # 관리자 
  get 'managers/reviews', to: "managers#reviews"
  get 'managers/reviews/:id', to: "managers#reviews_edit"
    # 증빙 확인
  put 'managers/reviews/:id', to: "managers#reviews_update"
  patch 'managers/reviews/:id', to: "managers#reviews_update"
    # 리뷰 확인
  post '/review_reject/:review_id', to: "review_confirms#reject_create"
  post '/review_confirm/:review_id', to: "review_confirms#confirm_create"
    # 리뷰 수정 확인
  post 'edit_reject/:id', to: "review_confirms#edit_reject_create"
  post 'edit_confirm/:id', to: "review_confirms#edit_confirm_create"
  
  get "managers/owner_comments", to: "managers#owner_comments"
  post '/owner_comment_reject/:owner_comment_id', to: "owner_comment_confirms#reject_create"
  post '/owner_comment_confirm/:owner_comment_id', to: "owner_comment_confirms#confirm_create"
  post 'edit_owner_comment_reject/:owner_comment_id', to: "owner_comment_confirms#edit_reject_create"
  post 'edit_owner_comment_confirm/:owner_comment_id', to: "owner_comment_confirms#edit_confirm_create"

  get 'managers/exchanges', to: "managers#exchanges"
  post '/exchange_reject/:req_exc_id', to: "exchange_confirms#reject_create"
  post '/exchange_confirm/:req_exc_id', to: "exchange_confirms#confirm_create"
  
  devise_for :users, path: 'users'
  devise_scope :user do
    post "/users/sign_up", to: "devise/registrations#new"
  end
  get '/users/sign_up_before_policy', to: "policies#sign_up_before_policy"
  get '/users/sign_up', to: "policies#sign_up_before_policy"
  get '/users', to: "policies#sign_up_before_policy"


  get '/policies/:type', to: "policies#policy"

  if Rails.env.production?
    match '404', :to => 'errors#not_found', :via => :all
    match '500', :to => "errors#internal_server_error", :via => :all
  end
end
