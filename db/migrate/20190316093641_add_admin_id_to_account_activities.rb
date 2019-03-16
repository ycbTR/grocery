class AddAdminIdToAccountActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :account_activities, :admin_id, :integer
  end
end
