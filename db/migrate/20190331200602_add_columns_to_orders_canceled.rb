class AddColumnsToOrdersCanceled < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :canceled_by, :integer
    add_column :line_items, :canceled_by, :integer
  end
end
