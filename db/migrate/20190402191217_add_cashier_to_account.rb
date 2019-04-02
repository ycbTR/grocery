class AddCashierToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :cashier, :boolean
  end
end
