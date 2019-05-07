class OrdersController < AdminController
  skip_before_action :authorize_admin!, only: [:populate, :complete, :remove_item, :show, :print]
  skip_before_action :session_expiry, only: [:populate, :complete, :remove_item, :show]
  skip_before_action :update_activity_time, only: [:populate, :complete, :remove_item, :show]

  before_action :account_required!, only: [:show]
  before_action :set_order, only: [:show, :edit, :update, :destroy, :cancel, :print]
  before_action :authorize_admin_cashier!, only: [:print]

  # GET /orders
  # GET /orders.json
  def index
    params[:q] ||= {}

    if (@current_account.cashier? or @current_account.second_admin?) && !@current_account.admin?
      params[:q][:completed_at_gteq] = 18.hours.ago
    end

    unless params[:all]
      params[:q][:state_cont] ||= 'completed'
    end

    if params[:q][:completed_at_cont].present?
      @date = params[:q][:completed_at_cont].to_date
      params[:q][:completed_at_gteq] = @date.beginning_of_day
      params[:q][:completed_at_lteq] = @date.end_of_day
      params[:q].delete :completed_at_cont
    end

    if params[:q][:state_cont] == "-1"
      params[:all] = true
      params[:q].delete :state_cont
    end

    @q = Order.where(state: ['completed', 'canceled']).ransack(params[:q])
    if request.format.xls?
      filename = "Siparişler_#{I18n.localize(Time.current, format: :custom)}.xls"
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
      @orders = @q.result(distinct: true).order(:completed_at => :desc)
    else
      @orders = @q.result(distinct: true).page(params[:page]).order(:completed_at => :desc)
      @page_total = @orders.sum(:total)
    end
  end

  def populate
    @order = current_order
    li = @order.add_to_order(params[:product_id])
    if li.product.count_on_hand <= @order.line_items.where(product_id: params[:product_id]).sum(:quantity)
      @li = li
    end
  end

  def remove_item
    @order = current_order
    if params[:empty]
      @product_ids_to_show = @order.line_items.pluck(:product_id)
      @order.line_items.destroy_all
    else
      @product_ids_to_show = @order.line_items.where(id: params[:line_item_id]).pluck(:product_id)
      @order.line_items.where(id: params[:line_item_id]).destroy_all
    end
    @order.update!
    render :populate
  end

  def complete
    # Start card listener
    # Cart listener will ping back here with account
    # If account id presents and it has enough balance, then complete the order
    # Decrease balances
    # Log request
    current_order

    redirect_to root_path and return if @order.line_items.blank?

    if params[:card].present?
      account = Account.where(card: params[:card]).first
      if account.blank?
        flash['warning'] = 'Kart tanımlanamadı...'
        redirect_to root_path and return
      end
      # Admin can add expense to any account.
      if (account.has_special_role?) && params[:account_id].present?
        admin_account = account
        account = Account.where(id: params[:account_id]).first
      end

      if account and account.enough_balance?(@order.total.to_f)
        begin
          Order.transaction do
            @order.account = account
            @order.completed_at = Time.now
            @order.state = 'completed'
            account.balance = account.balance.to_f - @order.total.to_f
            account.save!
            account.account_activities.create!(amount: @order.total.to_f * -1, order_id: @order.id, source: @order, admin_id: admin_account.try(:id))
            @order.save!
            @order.after_complete
          end
          session[:order_id] = nil
          flash[:success] = "#{account.name} ₺#{@order.total} Ödeme alındı. Kalan bakiyeniz: ₺ #{account.balance}"
          redirect_to root_path
        rescue Exception => e
          # Stop listener
          flash[:error] = "Hata - #{e.message}"
          redirect_to root_path
        ensure
          #stop listener
        end
      else
        flash[:error] = "Bakiye yetersiz. Bakiyeniz: ₺ #{account.try(:balance)}"
        redirect_to root_path
        # Stop listener
      end
    end

    # r = `sudo python rfidreader.py`
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    unless @current_account.can_manage_order?
      @order = @current_account.orders.where(id: params[:id]).first
      redirect_to root_path and return if @order.blank?
    end
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def print
    @order.print
    flash[:success] = "Yazdırılıyor..."
    redirect_to order_path(@order)
  end

  def cancel
    @order.cancel!
    flash[:success] = "İptal edildi"
    redirect_to order_path(@order)
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:account_id, :total, :completed_at)
  end
end
