class AddNegativeBalanceLimitToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :credit_limit, :decimal
  end
end
