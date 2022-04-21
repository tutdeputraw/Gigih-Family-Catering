require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should have_many(:order_items).class_name('OrderItem') }
    it { should have_many(:menu_items).class_name('MenuItem') }
  end
end