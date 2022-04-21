require 'rails_helper'

RSpec.describe ItemCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:menu_item).class_name('MenuItem') }
    it { should belong_to(:menu_category).class_name('MenuCategory') }
  end
end