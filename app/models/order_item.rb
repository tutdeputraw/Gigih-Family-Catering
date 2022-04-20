class OrderItem < ApplicationRecord
  belongs_to :item_category
  belongs_to :order
end
