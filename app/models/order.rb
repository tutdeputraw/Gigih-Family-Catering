class Order < ApplicationRecord
  has_many :order_items
  has_many :menu_items, :through => :order_items

  validates :email, presence: true, format: {
    with: /\A[\w+\-.]+@[a-z\d\-.]+\.[c][o][m]\z/,
    message: 'wrong format'
  }
end
