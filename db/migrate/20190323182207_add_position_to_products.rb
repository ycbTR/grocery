class AddPositionToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :position, :integer
  end
end
