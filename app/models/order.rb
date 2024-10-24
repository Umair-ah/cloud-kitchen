class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items, dependent: :destroy

  enum status: {
    "pending": 0,
    "out for delivery": 1,
    "completed": 2,
    "cancelled": 3
  }

  enum paid_status: {
    "failed": 0,
    "paid": 1,
    "payment_verified": 2
  }
end
