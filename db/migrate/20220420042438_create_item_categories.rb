class CreateItemCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :item_categories do |t|
      t.references :menu_item, null: false, foreign_key: true
      t.references :menu_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
