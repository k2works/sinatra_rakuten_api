# -*- coding: utf-8 -*-
require './config.rb'
require './model.rb'

before do
  @title = 'Shinatra Rakuten Api'
  @custom_css = 'custom.css'
  @item_search_link = '/item_search'
  @genre_search_link = '/genre_search'
  @item_ranking_link = '/item_ranking'
  @genre_ranking_link = '/genre_ranking'
  @create_link = '/create'
  @item_search_data_link = '/item_search_data'
  @item_search_data_download_link = 'csv/item_search_data'
  @genre_search_data_link = '/genre_search_data'
  @genre_search_data_download_link = 'csv/genre_search_data'  
  @item_ranking_data_link = '/item_ranking_data'
  @item_ranking_data_download_link = 'csv/item_ranking_data'  
  @genre_ranking_data_link = '/genre_ranking_data'
  @genre_ranking_data_download_link = 'csv/genre_ranking_data'
end

get '/' do
  erb :index
end

get '/item_search' do
  @items = RakutenWebService::Ichiba::Item.search(:keyword => 'Ruby') 
  erb :item_search
end

get '/genre_search' do
  # root genre
  @root = RakutenWebService::Ichiba::Genre.root  
  erb :genre_search
end

get '/item_ranking' do
  # 30代男性 のランキングTOP 30
  @rankings = RakutenWebService::Ichiba::Item.ranking(:age => 30, :sex => 0)
  erb :item_ranking
end

get '/genre_ranking' do
  RakutenWebService::Ichiba::Genre.root
  # "水・ソフトドリンク" ジャンルのTOP 30
  #  @rankings = RakutenWebService::Ichiba::Genre[100316].ranking
  @rankings = RakutenWebService::Ichiba::Genre[200163].ranking  
  erb :genre_ranking
end

get '/create' do
  erb :create
end

post '/create_item_search' do
  @items = RakutenWebService::Ichiba::Item.search(:keyword => 'Ruby')
  @items.first(10).each do |item|
    search_item = ItemSearch.find_by_name(item.name) || ItemSearch.new
    search_item[:name] = item.name
    search_item[:price] = item.price
    search_item.save
  end

  redirect '/item_search_data'
end

get '/item_search_data' do
  @items = ItemSearch.all
  erb :item_search_data
end

post '/create_genre_search' do
  @root = RakutenWebService::Ichiba::Genre.root  
  @root.children.each do |item|
    genre_item = GenreSearch.find_by_genre_id(item.id) || GenreSearch.new
    genre_item[:genre_id] = item.id
    genre_item[:name] = item.name
    genre_item.save
  end

  redirect '/genre_search_data'
end

get '/genre_search_data' do
  @root = GenreSearch.all
  erb :genre_search_data
end

post '/create_item_ranking' do
  @rankings = RakutenWebService::Ichiba::Item.ranking(:age => 30, :sex => 0)
  @rankings.each do |item|
    ranking_item = ItemRanking.find_by_name(item.name) || ItemRanking.new
    ranking_item[:name] = item.name
    ranking_item[:price] = item.price
    ranking_item.save
  end

  redirect '/item_ranking_data'
end

get '/item_ranking_data' do
  @rankings = ItemRanking.all
  erb :item_ranking_data
end

post '/create_genre_ranking' do
  RakutenWebService::Ichiba::Genre.root
  #  @rankings = RakutenWebService::Ichiba::Genre[100316].ranking
  @rankings = RakutenWebService::Ichiba::Genre[200163].ranking  
  @rankings.each do |item|
    ranking_item = GenreRanking.find_by_name(item.name) || GenreRanking.new
    ranking_item[:rank] = item.rank
    ranking_item[:name] = item.name
    ranking_item[:genre_id] = item.genre_id
    if GenreSearch.find_by_genre_id(item.genre_id).nil?
      ranking_item[:genre_name] = ''
    else
      ranking_item[:genre_name] = GenreSearch.find_by_genre_id(item.genre_id).name
    end    
    
#    ranking_item[:title] = item.title
#    ranking_item[:last_build_date] = item.last_build_date    
    ranking_item.save
  end

  redirect '/genre_ranking_data'
end

get '/genre_ranking_data' do
  @rankings = GenreRanking.all
  erb :genre_ranking_data
end

get '/csv/:file' do
  file = @params[:file]

  content_type 'text/csv'
  attachment file + '.' + 'csv'
    
  case file
  when 'item_search_data' then ItemSearch.to_csv
  when 'genre_search_data' then GenreSearch.to_csv
  when 'item_ranking_data' then ItemRanking.to_csv
  when 'genre_ranking_data' then GenreRanking.to_csv        
  end
end

get '/work' do
  @root = RakutenWebService::Ichiba::Genre.root

  @root.children.each do |root_item|
    case root_item.id
    when 200163 then next
    when 101114 then next
    when 101381 then next
    when 402853 then next
    when 100000 then next        
    else
      GenreRanking.transaction do      
        @rankings = RakutenWebService::Ichiba::Genre[root_item.id].ranking       
        puts 'genre_id:' + root_item.id.to_s
        
        @rankings.each do |item|
          ranking_item = GenreRanking.find_by_name(item.name) || GenreRanking.new
          ranking_item[:rank] = item.rank
          ranking_item[:name] = item.name
          ranking_item[:genre_id] = item.genre_id
          ranking_item[:genre_name] = root_item.name
          ranking_item[:item_code] = item.code
          ranking_item[:item_price] = item.price
          ranking_item[:review_count] = item.review_count
          ranking_item[:review_average] = item.review_average
          ranking_item[:shop_name] = item.shop_name
          ranking_item[:shop_code] = item.shop_code
          ranking_item.save
        end      
      end
    end  
  end
  
  redirect '/genre_ranking_data'  
end


after do
end
