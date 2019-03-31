class AddColumnsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :state, :string
    add_column :line_items, :state, :string
  end
end
