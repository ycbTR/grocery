class AccountActivity < ApplicationRecord
  belongs_to :account
  belongs_to :order, required: false
  belongs_to :source, polymorphic: true, required: false
  after_save :update_account
  after_destroy :update_account

  def update_account
    self.account.update_balance
  end

  def self.add_balance
    where(source_type: 'Account')
  end

  def self.refund_balance
    where(source_type: ['Order', 'LineItem'])
  end

  def admin
    @admin ||= if admin_id.present?
                 Account.where(id: admin_id).first
               end
  end

end
