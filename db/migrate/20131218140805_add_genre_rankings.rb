class AddGenreRankings < ActiveRecord::Migration
  def change
    add_column :genre_rankings, :genre_id, :integer
    add_column :genre_rankings, :genre_name, :string
    add_column :genre_rankings, :title, :string
    add_column :genre_rankings, :last_build_date, :datetime
  end
end
