class HomeController < ApplicationController
  before_action :account_required!, only: [:account_details]

  def index
    @products = Product.all
    @order = current_order(false)
  end

  def account_details
    @account_activities = @current_account.account_activities
  end

  def login
    unless request.get?
      if params[:card].present?
        account = Account.where(card: params[:card]).first
        session[:account_id] = account.id
      end
      redirect_to account_details_home_path
    end
  end

  def logout
    session.delete :account_id
    flash[:success] = "Çıkış yapıldı"
    redirect_to root_path
  end

end