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
  @rankings = RakutenWebService::Ichiba::Genre[100316].ranking
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
  erb :item_search
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
  erb :index
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
  erb :item_ranking  
end

post '/create_genre_ranking' do
  RakutenWebService::Ichiba::Genre.root
  @rankings = RakutenWebService::Ichiba::Genre[100316].ranking
  @rankings.each do |item|
    ranking_item = GenreRanking.find_by_name(item.name) || GenreRanking.new
    ranking_item[:rank] = item.rank
    ranking_item[:name] = item.name
    ranking_item.save
  end

  redirect '/genre_ranking_data'
end

get '/genre_ranking_data' do
  @rankings = GenreRanking.all
  erb :genre_ranking  
end

after do
end
