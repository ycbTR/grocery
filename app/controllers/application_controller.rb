class ApplicationController < ActionController::Base
  before_action :set_current_account
  # rescue_from Exception, with: :rescued_request


  def session_expiry
    get_session_time_left
    if @current_account and @session_time_left.to_f < 0
      flash[:error] = "Oturumunuz sona erdi. Tekrar giriş yapınız."
      session.delete :account_id
      session.delete :expires_at
      respond_to do |format|
        format.html { redirect_to root_path and return }
        format.js { render js: 'window.location.reload();' and return }
      end
    end
  end


  def rescued_request
    flash[:warning] = "Error occured"
    redirect_to root_path and return
  end

  def account_required!
    if @current_account.blank?
      flash[:warning] = 'Giriş yapınız'
      redirect_to root_path and return
    end
    update_activity_time
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

  private

  def get_session_time_left
    return nil if session[:expires_at].blank?
    expire_time = session[:expires_at].to_time
    @session_time_left = (expire_time - Time.now).to_i
  end

  def update_activity_time
    if params[:action] != "auto_logout"
      session[:expires_at] = 5.minutes.from_now
    end
  end
end
