class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :orders, [:state, :completed_at], name: 'o_i_1'
    add_index :line_items, [:state, :order_id], name: 'li_i_1'
    add_index :account_activities, [:source_type, :created_at, :amount], name: 'aa_i_1'
    add_index :account_activities, [:admin_id, :amount, :created_at], name: 'aa_i_2'
    add_index :accounts, [:name], name: 'acc_i_1'
    add_index :accounts, [:deleted_at], name: 'acc_i_2'
    add_index :products, [:name], name: 'pr_i_1'
    add_index :products, [:deleted_at], name: 'pr_i_2'
  end
end
