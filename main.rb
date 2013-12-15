# -*- coding: utf-8 -*-
require './config.rb'
require 'sinatra'

before do
  @title = 'Shinatra Rakuten Api'
  @custom_css = 'custom.css'
  @item_search_link = '/item_search'
  @genre_search_link = '/genre_search'
  @item_ranking_link = '/item_ranking'
  @genre_ranking_link = '/genre_ranking'
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

after do
end
