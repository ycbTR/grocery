class Order < ApplicationRecord
  belongs_to :account, required: false
  has_many :line_items
  has_many :account_activities, as: :source, dependent: :destroy
  after_destroy :update_account

  def self.not_canceled
    where(state: 'completed')
  end

  def self.completed
    where(state: 'completed')
  end

  def after_complete
    self.line_items.each(&:decrease_units)
    print
  end

  def print
    begin
      self.update_column(:printed_count, self.printed_count.to_i + 1)
      Printer.print(self)
    rescue

    end
  end

  def update_account
    refund_total
    self.account.update_balance
  end

  def refund_total
    account.
        account_activities.
        create!(
            amount: self.total.to_f,
            order_id: self.id,
            source: self,
            admin_id: Account.current.try(:id))
  end

  def name
    "Sipariş ##{self.id}"
  end

  def cancel!
    self.state = 'canceled'
    self.canceled_by = Account.current.try(:id)
    self.update!
    self.update_account # Refunds
    self.line_items.update_all(state: 'canceled')
    self.line_items.each(&:increase_units)
    self.update!
  end

  def canceled?
    self.state == 'canceled'
  end

  def update!
    self.total = self.line_items.not_canceled.sum(:total)
    self.save
  end

  def add_to_order(product_id)
    li = self.line_items.new(product_id: product_id)
    li.quantity = 1
    li.save
    li
  end

  #  authorize 'admin'
  #  authorize 'second_admin'
  #  authorize 'cashier'
  #  authorize! 'cashier'

  def authorize(required_role)
    self.send required_role.to_sym
  end

  def authorize!(required_role)
        unless authorize(required_role)
          raise Grocery::AccessDenied
        end
  end


  def order_display_text
    line_items.group(:product_id).pluck('sum(quantity) as quantity, product_id').collect do |quantity, pid |
      product = Product.find(pid)
      "#{quantity} #{product.name}"
    end.to_sentence
  end

  def grouped_items
    line_items.not_canceled.group(:product_id).pluck('sum(total), sum(quantity), product_id').collect do |li|
      {name: Product.where(id: li[2]).pluck(:name).first, count: li[1], total: li[0]}
    end
  end

end
