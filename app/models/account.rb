class Account < ApplicationRecord

  has_many :orders
  has_many :account_activities
  has_many :managed_account_activities, class_name: 'AccountActivity', as: :source
  validates :card, uniqueness: true, presence: true
  validates :name, presence: true
  after_create :set_account_activity

  def self.active
    where(deleted_at: nil)
  end

  def self.free
    where(free: true)
  end

  def has_special_role?
    admin? or second_admin? or cashier?
  end
  def can_print?
    admin? or cashier?
  end

  def can_manage_order?
    can_cancel?
  end

  def can_cancel?
    admin? or second_admin?
  end

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
    self.account_activities.create(amount: self.balance.to_f, source: Account.current, admin_id: Account.current.id)
  end

  def destroy
    self.touch :deleted_at
  end

  def balance_health
    case self.balance.to_f
      when proc { |n| n <= 0 }
        'badBalance'
      when 0.1..9.9
        'averageBalance'
      else
        'goodBalance'
    end
  end

end
