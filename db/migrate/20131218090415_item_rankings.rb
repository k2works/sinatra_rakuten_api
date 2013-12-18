class ItemRankings < ActiveRecord::Migration
  def change
    create_table :item_rankings do |t|
      t.string :name
      t.decimal :price
    end
  end
end
