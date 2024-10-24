class AddPaidStatusToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :paid_status, :integer
  end
end
