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
+ [楽天APIを使ったアプリケーション]()

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
            
+ [ビュー追加](views/item_search.rb)

### ジャンル ###

+ [SDKによるデータ取得](ichibagenresearch.rb)

### 市場商品ランキング ###

+ [SDKによるデータ取得](ichibaitemranking.rb)


# 参照 #
