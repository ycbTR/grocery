class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.integer :product_id
      t.integer :stock
      t.integer :account_id

      t.timestamps
    end
  end
end
