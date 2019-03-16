class AddSourceFieldsToAccountActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :account_activities, :source_type, :string
    add_column :account_activities, :source_id, :integer
  end
end
