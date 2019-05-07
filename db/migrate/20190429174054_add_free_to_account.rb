class AddFreeToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :free, :boolean, default: false
  end
end
