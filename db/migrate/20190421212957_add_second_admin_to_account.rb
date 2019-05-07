class AddSecondAdminToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :second_admin, :boolean
  end
end
