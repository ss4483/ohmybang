class OwnerCommentConfirmsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_manager


  def reject_create
    owner_comment = OwnerComment.find(params[:owner_comment_id])


    owner_comment.update_columns(status: "등록반려") 


    owner_comment_confirm = OwnerCommentConfirm.new
    owner_comment_confirm.memo = params[:memo]
    owner_comment_confirm.status = "등록반려"
    owner_comment_confirm.owner_comment =  owner_comment
    owner_comment_confirm.save
    
    flash[:info] = "정상적으로 \"반려\" 되었습니다."
    redirect_back(fallback_location: root_path)
  end

  def confirm_create
    owner_comment = OwnerComment.find(params[:owner_comment_id])
    owner_comment.update_columns(status: "등록완료") 

    owner_comment_confirm = OwnerCommentConfirm.new
    owner_comment_confirm.status = "등록완료"
    owner_comment_confirm.owner_comment = owner_comment
    owner_comment_confirm.save

    owner_comment.owner_comment_imp_imgs.destroy_all if OwnerCommentConfirm.where(owner_comment: owner_comment, status: "등록완료").count == 1

    flash[:info] = "정상적으로 \"완료\" 되었습니다."
    redirect_back(fallback_location: root_path)
  end

  def edit_reject_create
    owner_comment = OwnerComment.find(params[:owner_comment_id])

    owner_comment.update_columns(status: "수정반려") 

    owner_comment_confirm = OwnerCommentConfirm.new
    owner_comment_confirm.memo = params[:memo]
    owner_comment_confirm.status = "수정반려"
    owner_comment_confirm.owner_comment =  owner_comment
    owner_comment_confirm.save
    
    flash[:info] = "정상적으로 \"반려\" 되었습니다."
    redirect_back(fallback_location: root_path)
  end

  def edit_confirm_create
    owner_comment = OwnerComment.find(params[:owner_comment_id])
    edit = owner_comment.edit_owner_comment
    
    owner_comment.hidden_camera = edit.hidden_camera
    owner_comment.contact_time = edit.contact_time
    owner_comment.contact_method = edit.contact_method
    owner_comment.long_term_txt = edit.long_term_txt
    owner_comment.remodeling_date = edit.remodeling_date
    owner_comment.remodeling_txt = edit.remodeling_txt
    owner_comment.intro_txt = edit.intro_txt

    owner_comment.status = "등록완료"
    owner_comment.save          

    owner_comment.owner_comment_imgs.destroy_all
    edit.owner_comment_imgs.each do |img|
      img.owner_comment = owner_comment
      img.save
    end

    edit.destroy

    owner_comment_confirm = OwnerCommentConfirm.new
    owner_comment_confirm.status = "등록완료"
    owner_comment_confirm.owner_comment =  owner_comment
    owner_comment_confirm.save
    
    flash[:info] = "정상적으로 \"완료\" 되었습니다."
    redirect_back(fallback_location: root_path)
  end
end
