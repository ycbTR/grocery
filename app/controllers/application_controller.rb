class ApplicationController < ActionController::Base
  before_action :set_current_account

  def account_required!
    if @current_account.blank?
      flash[:warning] = 'Giriş yapınız'
      redirect_to root_path and return
    end
    @logged_in = true
  end

  def set_current_account
    @current_account = Account.where(id: session[:account_id]).first
  end

  def current_order(create_if_necessary = true)
    @order = Order.where(id: session[:order_id]).first
    if create_if_necessary && @order.blank?
      @order = Order.create!
    end
    session[:order_id] = @order.try(:id)
    @order
  end

end
