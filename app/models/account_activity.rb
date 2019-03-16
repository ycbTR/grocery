class AccountActivity < ApplicationRecord
  belongs_to :account
  belongs_to :order, required: false
  belongs_to :source, polymorphic: true, required: false
  after_save :update_account


  def update_account
    self.account.update_balance
  end

end
