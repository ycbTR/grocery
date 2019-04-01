class Account < ApplicationRecord

  has_many :orders
  has_many :account_activities
  has_many :managed_account_activities, class_name: 'AccountActivity', as: :source
  validates :card, uniqueness: true
  after_create :set_account_activity

  def enough_balance?(amount)
    (self.balance.to_f + self.credit_limit.to_f) >= amount.to_f
  end

  def update_balance
    self.balance = self.account_activities.sum(:amount)
    self.save!
  end

  def self.current=(val)
    Thread.current[:account] = val
  end

  def self.current
    Thread.current[:account]
  end

  def set_account_activity
    self.account_activities.create(amount: self.balance.to_f, source: Account.current, admin_id: Account.current.id )
  end


end
