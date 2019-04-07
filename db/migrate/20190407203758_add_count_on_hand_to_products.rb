class AddCountOnHandToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :count_on_hand, :integer, default: 0
    add_column :products, :active, :boolean, default: true
    add_index :products, [:active, :count_on_hand], name: 'pi_2'
    Product.reset_column_information
    Product.where(deleted_at: nil).update_all(active: true)
  end
end
