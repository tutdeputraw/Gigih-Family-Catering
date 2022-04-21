require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'associations' do
    it { should have_many(:menu_categories).class_name('MenuCategory') }
    it { should have_many(:item_categories).class_name('ItemCategory') }
    it { should have_many(:order_items).class_name('OrderItem') }
    it { should have_many(:orders).class_name('Order') }
  end
end