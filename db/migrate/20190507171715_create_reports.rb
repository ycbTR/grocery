class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :report_type
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :account_id

      t.timestamps
    end
  end
end
