class GenreRankings < ActiveRecord::Migration
  def change
    create_table :genre_rankings do |t|
      t.integer :rank
      t.string :name
    end
  end
end
