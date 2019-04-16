class AddPrintedCountToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :printed_count, :integer
  end
end
