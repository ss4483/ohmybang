class PoliciesController < ApplicationController
  def policy
    render :layout => false     
  end

  def sign_up_before_policy
    if user_signed_in?
      redirect_back(fallback_location: root_path)
    end
  end
end
