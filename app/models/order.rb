class Order < ApplicationRecord
  belongs_to :account, required: false
  has_many :line_items
  has_many :account_activities, as: :source

  def name
    self.id
  end

  def update!
    self.total = self.line_items.reload.sum(:total)
    self.save
  end

  def add_to_order(product_id)
    li = self.line_items.new(product_id: product_id)
    li.quantity = 1
    li.save
  end

  def order_display_text
    line_items.group(:product_id).count.collect do |pid, count|
      product = Product.find(pid)
      "#{count} #{product.name}"
    end.to_sentence
  end

end
