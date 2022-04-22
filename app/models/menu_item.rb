class MenuItem < ApplicationRecord
  has_many :item_categories
  has_many :menu_categories, through: :item_categories

  has_many :order_items
  has_many :orders, :through => :order_items

  validates :name, presence: true, uniqueness: true

  validates_numericality_of :price, greater_than_or_equal_to: 0.01, presence: true

  validates :description, :length => { :maximum => 150 }, presence: true

  validates :item_categories, presence: true
end
