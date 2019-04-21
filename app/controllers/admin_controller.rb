class AdminController < ApplicationController
  before_action :session_expiry
  before_action :update_activity_time
  before_action :authorize_admin!



  def auto_logout
       render js: 'ok'
  end

  def authorize_only_admin!
    if @current_account && (@current_account.admin?)
      # Valid admin login
      Account.current = @current_account
    else
      redirect_to account_details_home_path and return
    end
  end

  def authorize_admin!
    if @current_account && (@current_account.admin? || @current_account.second_admin?)
      # Valid admin login
      Account.current = @current_account
    else
      redirect_to account_details_home_path and return
    end
    @logged_in = true
  end

  def authorize_admin_cashier!
    if @current_account && (@current_account.admin? || @current_account.second_admin? || @current_account.cashier?)
      # Valid admin login
      Account.current = @current_account
    else
      redirect_to root_path and return
    end
    @logged_in = true
  end

  def authorize_admin_second_admin!
    if @current_account && (@current_account.admin? || @current_account.second_admin?)
      # Valid admin login
      Account.current = @current_account
    else
      redirect_to root_path and return
    end
    @logged_in = true
  end

end
