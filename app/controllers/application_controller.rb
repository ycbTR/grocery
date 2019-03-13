class ApplicationController < ActionController::Base

  def current_order(create_if_necessary = true)
    @order = Order.where(id: session[:order_id]).first
    if create_if_necessary && @order.blank?
      @order = Order.create!
    end
    session[:order_id] = @order.try(:id)
    @order
  end

end
