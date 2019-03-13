class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
