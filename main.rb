require 'sinatra'

before do
  @title = 'Shinatra Rakuten Api'
end

get '/' do
  @custom_css = 'custom.css'
  erb :index
end

after do
end
