class ItemSearch < ActiveRecord::Base
  validates_presence_of :name
end

class GenreSearch < ActiveRecord::Base
  validates_presence_of :genre_id
end

class ItemRanking < ActiveRecord::Base
  validates_presence_of :name
end

class GenreRanking < ActiveRecord::Base
  validates_presence_of :name
end
