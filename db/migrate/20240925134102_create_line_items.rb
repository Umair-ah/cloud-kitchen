class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :cart, foreign_key: true, type: :uuid
      t.belongs_to :product, null: false, foreign_key: true
      t.belongs_to :order, foreign_key: true
      t.integer :quantity, default: 0

      t.timestamps
    end
  end
end
