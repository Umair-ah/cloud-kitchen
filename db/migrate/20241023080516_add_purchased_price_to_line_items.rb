class AddPurchasedPriceToLineItems < ActiveRecord::Migration[7.0]
  def change
    add_column :line_items, :purchased_price, :decimal, null: true
  end
end
