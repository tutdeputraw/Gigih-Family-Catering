class Order < ApplicationRecord
  has_many :order_items
  has_many :item_categories, :through => :order_items
end
