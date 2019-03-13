class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      t.integer :order_id
      t.integer :quantity
      t.decimal :price
      t.decimal :total
      t.integer :product_id

      t.timestamps
    end
  end
end
