class AdminController < ApplicationController

  before_action :authorize_admin!

  def authorize_admin!
    if @current_account && @current_account.admin?
      # Valid admin login
      Account.current = @current_account
    else
      redirect_to account_details_home_path and return
    end
    @logged_in = true
  end

  def authorize_admin_cashier!
    if @current_account && (@current_account.admin? || @current_account.cashier?)
      # Valid admin login
      Account.current = @current_account
    else
      redirect_to root_path and return
    end
    @logged_in = true
  end

end