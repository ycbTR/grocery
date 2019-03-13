class AddAdminToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :admin, :boolean
  end
end
