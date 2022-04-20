class MenuCategory < ApplicationRecord
  has_many :item_categories
  has_many :menu_items, through: :item_categories
end
