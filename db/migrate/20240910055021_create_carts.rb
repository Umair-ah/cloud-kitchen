class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
