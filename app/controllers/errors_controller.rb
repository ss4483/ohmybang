class ErrorsController < ApplicationController
  def not_found
    render :layout => false
  end
  def internal_server_error
    render :layout => false
  end
end