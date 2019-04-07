class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  after_save :update_prices
  attr_accessor :dont_update_prices


  def self.not_canceled
    where("state IS NULL OR state != ?", 'canceled')
  end

  def update_prices
    unless dont_update_prices
      self.update_columns(price: product.price, total: self.product.price.to_f * self.quantity.to_f)
      self.order.update!
    end
  end

  def canceled?
    self.state == 'canceled'
  end

  def name
    self.order.name
  end

  def to_link
    self.order
  end

  def cancel!
    if self.order.line_items.not_canceled.count == 1
      self.order.cancel!
    else
      self.state = 'canceled'
      self.canceled_by = Account.current.try(:id)
      self.dont_update_prices = true
      self.save
      self.order.update!
      increase_units
      account = self.order.account
      account.
          account_activities.
          create!(
              amount: self.total.to_f,
              order_id: self.order_id,
              source: self,
              admin_id: Account.current.try(:id))
    end
  end

  def increase_units
    self.product.update_column(:count_on_hand, self.product.count_on_hand.to_f + 1)
  end

  def decrease_units
    self.product.update_column(:count_on_hand, self.product.count_on_hand.to_f - 1)
  end

end
