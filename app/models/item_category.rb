class ItemCategory < ApplicationRecord
  belongs_to :menu_item
  belongs_to :menu_category

  has_many :order_items
  has_many :orders, :through => :order_items
end
