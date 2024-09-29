class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items


  def subtotal
    sum = 0
    self.line_items.each do |line_item|
      sum+=line_item.product.price * line_item.quantity
    end
    return sum
  end
end
