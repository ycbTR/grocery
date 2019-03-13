class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :account_id
      t.decimal :total
      t.datetime :completed_at

      t.timestamps
    end
  end
end
