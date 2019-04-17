class Product < ApplicationRecord
  has_one_attached :image
  has_many :stocks
  after_create :create_stock
  before_save :check_stock

  def self.active
    where(deleted_at: nil, active: 1).where("count_on_hand > 0")
  end

  def destroy
    self.touch :deleted_at
  end

  def check_stock
    if !self.new_record? and self.count_on_hand_changed?
      create_stock
    end
  end

  def create_stock
    if self.count_on_hand_changed?
      self.stocks.create(stock: (self.count_on_hand.to_f - self.count_on_hand_was.to_f), account_id: Account.current.try(:id))
    else
      self.stocks.create(stock: (self.count_on_hand.to_f), account_id: Account.current.try(:id))
    end
  end

end
