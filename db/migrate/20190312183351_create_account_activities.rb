class CreateAccountActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :account_activities do |t|
      t.integer :order_id
      t.decimal :amount
      t.integer :account_id

      t.timestamps
    end
  end
end
