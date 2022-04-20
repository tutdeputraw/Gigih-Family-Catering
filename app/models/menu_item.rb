class MenuItem < ApplicationRecord
  has_many :item_categories
  has_many :menu_categories, through: :item_categories
end
