sinatraで楽天APIを利用したWebアプリを作る
===================

# 目的 #
楽天APIを利用したWebアプリを作成して公開する

# 前提 #
| ソフトウェア   | バージョン   | 備考        |
|:---------------|:-------------|:------------|
| OS X           |10.8.5        |             |
| ruby           |1.9.3-p392    |             |
| rvm            |1.24.0        |             |
| sinatra        |1.4.4         |             |
| thin           |1.6.0         |             |
| heroku-toolbelt   |3.1.1      |             |

+ 楽天登録済み
+ Heroku登録済み

# 構成 #
+ [セットアップ](#chap1)
+ [ベースアプリケーション](#chap2)
+ [デプロイ](#chap3)
+ [楽天APIを使ったアプリケーション](#chap4)
+ [ActiveRecordを使えるようにする](#chap5)
+ [CSVでエクスポート出来るようにする](#chap6)

# 詳細 #

## <a name="chap1">セットアップ ##

### セットアップ ###

    $ rvm use ruby-1.9.3-p392
    $ rvm gemset create sinatra_rakuten_api
    $ rvm use ruby-1.9.3-p392@sinatra_rakuten_api
    $ gem install bundler
    $ bundle init

## <a name="chap2">ベースアプリケーション ##

### ベースアプリケーションの作成 ###
    bash-3.2$ tree
    .
    ├── Gemfile
    ├── Guardfile
    ├── Procfile
    ├── README.md
    ├── config.ru
    ├── main.rb
    ├── public
    │   ├── css
    │   │   ├── bootstrap-theme.css
    │   │   ├── bootstrap-theme.min.css
    │   │   ├── bootstrap.css
    │   │   ├── bootstrap.min.css
    │   │   └── custom.css
    │   ├── fonts
    │   │   ├── glyphicons-halflings-regular.eot
    │   │   ├── glyphicons-halflings-regular.svg
    │   │   ├── glyphicons-halflings-regular.ttf
    │   │   └── glyphicons-halflings-regular.woff
    │   └── js
    │       ├── bootstrap.js
    │       └── bootstrap.min.js
    └── views
        ├── index.erb
        └── layout.erb

### Livereload 環境にする ###

    $ guard init
    $ foreman start

+ [Guardfile](classic/Guardfile)

+ [Procfile](classic/Procfile)

### Gemfileの作成 ###

+ [Gemfile](Gemfile)

+ bundle installを実行

+ ローカルで動作を確認する

        $ foreman start
    
### Heroku用Procfileの編集 ###

+ [Procfile](Procfile)

        web: bundle exec ruby main.rb -p $PORT

### Gitレポジトリの作成 ###

    $ git add .
    $ git commit -a -m "init"

## <a name="chap3">デプロイ ##

### ログイン ###

    $ heroku login

### Herokuにデプロイ ###

    $ heroku create
    $ git push heroku master

### アプリケーションの確認 ###

    $ heroku ps:scale web=1
    $ Scaling dynos... done, now running web at 1:1X.

    $ heroku ps
    === web (1X): `bundle exec ruby web.rb -p $PORT`
    web.1: up 2013/12/12 11:01:48 (~ 7m ago)

    $ heroku open

## <a name="chap4">楽天APIを使ったアプリケーション ##

### 設定 ###

+ [共通設定](config.rb)

+ Gemfileに追加

        gem 'rakuten_web_service'

### 市場商品の検索 ###

+ [コントローラ修正](main.rb)

        get '/item_search' do
            @items = RakutenWebService::Ichiba::Item.search(:keyword => 'Ruby') # This returns Enamerable object
            erb :item_search
        end
            
+ [ビュー追加](views/item_search.erb)

### ジャンル ###

+ [コントローラ修正](main.rb)

        get '/genre_search' do
          # root genre
          @root = RakutenWebService::Ichiba::Genre.root  
          erb :genre_search
        end
            
+ [ビュー追加](views/genre_search.erb)

### 市場商品ランキング ###

+ [コントローラ修正](main.rb)

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
            
+ ビュー追加
  + [商品ランキング](views/item_ranking.erb)
  + [ジャンルランキング](views/genre_ranking.erb)            

## <a name="chap5">ActiveRecordを使えるようにする ##

### セットアップ ###

+ Gemfileを編集する

        gem "sinatra-activerecord"
        gem "sqlite3"
        gem "rake"

+ config.rbを編集する

        require "sinatra/activerecord"
        set :database, "sqlite3:///rakuten_api.sqlite3"

+ Rakefileを追加する

        require "sinatra/activerecord/rake"
        require "./main"

+ Profileを修正する

        web: bundle exec rackup config.ru -p $PORT

+ 動作確認

        $ rake -T
        $ foreman start

### 商品検索データベースを作る ###

+ マイグレーションファイル作成

        $ rake db:create_migration NAME=item_searches

+ マイグレーションファイル編集

        class ItemSearch < ActiveRecord::Migration
          def change
            create_table :item_searches do |t|
              t.string :name
              t.decimal :price
            end
          end
        end

+ マイグレーション実行

        $ rake db:migrate

+ モデルファイルを作成

        class ItemSearch < ActiveRecord::Base
          validates_presence_of :name
        end

### 商品検索データ作成機能を作る ###

+ [作成ページ作成](create.erb)


+ [商品作成機能追加](main.rb)

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

## <a name="chap6">CSVでエクスポート出来るようにする ##

### csvライブラリを読み込めるようにする ###

+ [config.rb](config.rb)

        require 'csv'
        require 'kconv'

+ [モデルにcsvメソッドを追加](model.rb)

        def self.to_csv(options = {})
            csv_data = CSV.generate(options) do |csv|
              csv << column_names
              all.each do |account|
                csv << account.attributes.values_at(*column_names)
              end
            end
            
            csv_data = csv_data.tosjis
        end

+ [csvダウンロードメソッドを追加](main.rb)

        get '/csv/:file' do
          file = @params[:file]

          content_type 'text/csv'
          attachment file + '.' + 'csv'
    
          case file
          when 'ItemSearch' then ItemSearch.to_csv    
          end
        end

+ [ダウンロードリンクを追加する](views/item_search_data.erb)



# 参照 #

[楽天WEB SERVICE](http://webservice.rakuten.co.jp/)

[Ruby SDK](http://webservice.rakuten.co.jp/sdk/ruby.html)

[GitHub](https://github.com/rakuten-ws/rws-ruby-sdk)

[janko-m / sinatra-activerecord](https://github.com/janko-m/sinatra-activerecord)
