class AdminController < ApplicationController

  before_action :authorize_admin!

  def authorize_admin!
    if @current_account && @current_account.admin?
      # Valid admin login
    else
      flash[:warning] = "Yetkiniz yok."
      redirect_to root_path and return
    end
    @logged_in = true
  end

end