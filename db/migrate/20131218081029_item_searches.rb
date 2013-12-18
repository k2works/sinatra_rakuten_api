class ItemSearches < ActiveRecord::Migration
  def change
    create_table :item_searches do |t|
      t.string :name
      t.decimal :price
    end
  end
end
