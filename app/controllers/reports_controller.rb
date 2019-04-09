class ReportsController < AdminController

  before_action :set_times

  def index

  end

  def zreport
    @start_time = params[:start].to_time

    @end_time = params[:end].to_time
    #TODO Thinks utc time
    @orders = Order.completed.where("completed_at BETWEEN ? AND ?", @start_time, @end_time)
    @total = @orders.sum(:total)
    @line_items = LineItem.not_canceled.where(order_id: @orders.pluck(:id)).group(:product_id).pluck('sum(total), count(*), product_id')
    @product_report = {}
    @line_items.each do |li|
      @product_report[Product.where(id: li[2]).pluck(:name).first] = {count: li[1], total: li[0]}
    end

    @balance_added = AccountActivity.add_balance.
        where("created_at BETWEEN ? AND ?", @start_time, @end_time).
        where("amount > 0").sum(:amount)
    if request.format.xls?
      filename = "Z_Raporu_#{I18n.localize(@start_time, format: :custom)}_#{I18n.localize(@end_time, format: :custom)}.xls"
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
    end

  end

  private

  def set_times
    now = Time.current
    params[:start] = now.beginning_of_day if params[:start].blank?
    params[:end] = now.end_of_day if params[:end].blank?
  end
end