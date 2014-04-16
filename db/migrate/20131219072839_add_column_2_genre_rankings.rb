class AddColumn2GenreRankings < ActiveRecord::Migration
  def change
    add_column :genre_rankings, :item_code, :string
    add_column :genre_rankings, :item_price, :decimal
    add_column :genre_rankings, :review_count, :integer
    add_column :genre_rankings, :review_average, :decimal
    add_column :genre_rankings, :shop_code, :string
    add_column :genre_rankings, :shop_name, :string        
  end
end
