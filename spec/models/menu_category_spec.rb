require 'rails_helper'

RSpec.describe MenuCategory, type: :model do
  describe 'associations' do
    it { should have_many(:menu_items).class_name('MenuItem') }
    it { should have_many(:item_categories).class_name('ItemCategory') }
  end
end
