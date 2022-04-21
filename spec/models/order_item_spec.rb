require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'associations' do
    it { should belong_to(:menu_item).class_name('MenuItem') }
    it { should belong_to(:order).class_name('Order') }
  end
end