class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  after_save :update_prices


  def update_prices
    self.update_columns(price: product.price, total: self.product.price.to_f * self.quantity.to_f)
    self.order.update!
  end
end
