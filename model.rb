class ItemSearch < ActiveRecord::Base
  validates_presence_of :name

  def self.to_csv(options = {})
    csv_data = CSV.generate(options) do |csv|
      csv << column_names
      all.each do |account|
        csv << account.attributes.values_at(*column_names)
      end
    end
    
    csv_data = csv_data.tosjis
  end
end

class GenreSearch < ActiveRecord::Base
  validates_presence_of :genre_id

  def self.to_csv(options = {})
    csv_data = CSV.generate(options) do |csv|
      csv << column_names
      all.each do |account|
        csv << account.attributes.values_at(*column_names)
      end
    end
    
    csv_data = csv_data.tosjis
  end  
end

class ItemRanking < ActiveRecord::Base
  validates_presence_of :name

  def self.to_csv(options = {})
    csv_data = CSV.generate(options) do |csv|
      csv << column_names
      all.each do |account|
        csv << account.attributes.values_at(*column_names)
      end
    end
    
    csv_data = csv_data.tosjis
  end  
end

class GenreRanking < ActiveRecord::Base
  validates_presence_of :name

  def self.to_csv(options = {})
    csv_data = CSV.generate(options) do |csv|
      csv << column_names
      all.each do |account|
        csv << account.attributes.values_at(*column_names)
      end
    end
    
    csv_data = csv_data.tosjis
  end  
end
