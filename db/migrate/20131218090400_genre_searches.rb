class GenreSearches < ActiveRecord::Migration
  def change
    create_table :genre_searches do |t|
      t.integer :genre_id
      t.string :name
    end
  end
end
