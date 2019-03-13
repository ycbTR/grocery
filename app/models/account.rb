class Account < ApplicationRecord

  has_many :orders
  has_many :account_activities

  def enough_balance?(amount)
    self.balance.to_f >= amount.to_f
  end

  def update_balance
    self.balance = self.account_activities.sum(:amount)
    self.save!
  end

end
