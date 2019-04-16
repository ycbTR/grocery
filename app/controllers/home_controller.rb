class HomeController < ApplicationController
  before_action :account_required!, only: [:account_details]
  before_action :session_expiry, only: [:account_details]
  before_action :update_activity_time, only: [:account_details]

  def index

    Printer.print(3)

    @products = Product.includes(:image_attachment, :image_blob).active.order('position').to_a
    @order = current_order(false)
    @products_to_hide = []
    @order.line_items.group(:product_id).count.each do |pid, count|
      p = @products.select { |p| (p.id == pid) && p.count_on_hand <= count }
      @products_to_hide << p[0].id if p && p[0]
    end if @order
  end

  def reset_cart
    @order = current_order
    if @order
      @product_ids_to_show = @order.line_items.pluck(:product_id)
    end
    session.delete :order_id
    @order = nil
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

  def publish_backup
    ActionCable.server.broadcast 'publish_backup', status: params[:status]
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
