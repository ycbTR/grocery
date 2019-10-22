class ReportsController < AdminController
  skip_before_action :authorize_admin!
  before_action :authorize_admin_second_admin!

  # before_action :set_times

  def index

  end

  def zreport
    @start_time = params[:start].to_time if params[:start]
    @end_time = params[:end].to_time if params[:end]

    @end_time ||= Time.now
    @start_time ||= Report.last.try(:ends_at) || Time.now.beginning_of_day

    @orders = Order.completed.where("completed_at BETWEEN ? AND ?", @start_time, @end_time)
    @total = @orders.where("account_id not in(?)", Account.free.pluck(:id)).sum(:total).round(2)
    @total_free = @orders.where(account_id: Account.free.pluck(:id)).sum(:total).round(2)
    @line_items = LineItem.not_canceled.where(order_id: @orders.pluck(:id)).group(:product_id).pluck('sum(total) as total, sum(quantity) as count_all, product_id')
    @product_report = {}
    @line_items.each do |li|
      @product_report[Product.where(id: li[2]).pluck(:name).first] = {count: li[1], total: li[0].round(2)}
    end

    @balance_added_relation = AccountActivity.add_balance.
    where("created_at BETWEEN ? AND ?", @start_time, @end_time).
    where("account_id NOT IN(?)", Account.free.pluck(:id))

    @balance_added = @balance_added_relation.sum(:amount)
    @balance_added_ids = @balance_added_relation.pluck(:id)

    @balance_added_with_cancel_relation = AccountActivity.refund_balance.
    where("created_at BETWEEN ? AND ?", @start_time, @end_time).
    where("amount > 0")

    @balance_added_with_cancel = @balance_added_with_cancel_relation.sum(:amount)
    @balance_added_with_cancel_ids = @balance_added_with_cancel_relation.pluck(:id)


    if request.format.xls?
      filename = "Z_Raporu_#{I18n.localize(@start_time, format: :custom)}_#{I18n.localize(@end_time, format: :custom)}.xls"
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
    end

    if params[:print]
      Report.create(:ends_at => @end_time, starts_at: @start_time, report_type: 'zreport', account_id: @current_account.try(:id)) if params[:persist]
      Printer.print_z_report(@product_report, @orders, @total, @total_free, @balance_added, @balance_added_with_cancel, @start_time, @end_time)
      redirect_to zreport_reports_path
    end
  end


  def detailed_z_report

    @start_time = params[:start].to_time if params[:start]
    @end_time = params[:end].to_time if params[:end]

    @end_time ||= Time.now
    @start_time ||= Report.last.try(:ends_at) || Time.now.beginning_of_day

    if params[:account_id].present?
      @orders = Order.completed.where(account_id: params[:account_id]).where("completed_at BETWEEN ? AND ?", @start_time, @end_time)
    else
      @orders = Order.completed.where("completed_at BETWEEN ? AND ?", @start_time, @end_time)
    end

    @total = @orders.where("account_id not in(?)", Account.free.pluck(:id)).sum(:total).round(2)
    @total_free = @orders.where(account_id: Account.free.pluck(:id)).sum(:total).round(2)


    @report = {}
    @orders.each do |order|
      @report[order.account.try(:name)] ||= {}
      order.line_items.includes(:product).not_canceled.each do |li|
        @report[order.account.try(:name)][li.product.name] ||= 0
        @report[order.account.try(:name)][li.product.name] = @report[order.account.try(:name)][li.product.name] + li.quantity
      end
    end


    if params[:account_id].present?
      @balance_added_relation = AccountActivity.add_balance.
      where("created_at BETWEEN ? AND ?", @start_time, @end_time).
      where("account_id" => params[:account_id])

      @balance_added_with_cancel_relation = AccountActivity.refund_balance.
      where("created_at BETWEEN ? AND ?", @start_time, @end_time).
      where("amount > 0").where("account_id" => params[:account_id])
    else
      @balance_added_relation = AccountActivity.add_balance.
      where("created_at BETWEEN ? AND ?", @start_time, @end_time).
      where("account_id NOT IN(?)", Account.free.pluck(:id))

      @balance_added_with_cancel_relation = AccountActivity.refund_balance.
      where("created_at BETWEEN ? AND ?", @start_time, @end_time).
      where("amount > 0")
    end

    @balance_added = @balance_added_relation.sum(:amount)
    @balance_added_ids = @balance_added_relation.pluck(:id)

    @balance_added_with_cancel = @balance_added_with_cancel_relation.sum(:amount)
    @balance_added_with_cancel_ids = @balance_added_with_cancel_relation.pluck(:id)

    if request.format.xls?
      filename = "Detay_siparis_#{I18n.localize(@start_time, format: :custom)}_#{I18n.localize(@end_time, format: :custom)}.xls"
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
    end

    if params[:print]
      Report.create(:ends_at => @end_time, starts_at: @start_time, report_type: 'zreport', account_id: @current_account.try(:id)) if params[:persist]
      Printer.print_detail_z_report(@report, @orders, @total, @total_free, @balance_added, @balance_added_with_cancel, @start_time, @end_time)
      redirect_to detailed_z_report_reports_path
    end


  end

  private

  def set_times
    now = Time.current
    params[:start] = now.beginning_of_day if params[:start].blank?
    params[:end] = now.end_of_day if params[:end].blank?
  end
end
