class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.integer :quantity
      t.decimal :price, precision: 10, scale: 2
      t.string :ingredients
      t.belongs_to :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
