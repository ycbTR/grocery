class HomeController < ApplicationController

  def index
    @products = Product.all
    @order = current_order(false)
  end

end