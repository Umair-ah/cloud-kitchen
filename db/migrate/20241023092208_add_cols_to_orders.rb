class AddColsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :full_name, :string
    add_column :orders, :phone_number, :string
    add_column :orders, :shipping_address, :string
    add_column :orders, :razor_payment_id, :string
    add_column :orders, :razor_order_id, :string
    add_column :orders, :razor_signature, :string
    add_column :orders, :total_amount, :decimal
  end
end
