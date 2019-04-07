class HomeController < ApplicationController
  before_action :account_required!, only: [:account_details]

  def index
    @products = Product.active.order('position')
    @order = current_order(false)
  end

  def reset_cart
    session.delete :order_id
    respond_to do |format|
      format.js
    end
  end

  def account_details
    if @current_account && @current_account.admin? && params[:id].present?
      @account = Account.find(params[:id])
    else
      @account = @current_account
    end
    @account_activities = @account.account_activities.page(params[:page]).order(:created_at => :desc)
  end

  def publish_number
    account_id = Account.where(card: params[:card]).first.try(:id)
    ActionCable.server.broadcast 'rfid_read',
                                 card: params[:card], account_id: account_id
    render text: 'ok'
  end

  def read

  end

  def login
    unless request.get?
      if params[:card].present?
        account = Account.where(card: params[:card]).first
        if account
          session[:account_id] = account.id
        else
          flash['warning'] = "Kart tanımlanamadı..."
          redirect_to root_path and return
        end
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
