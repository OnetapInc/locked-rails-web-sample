# Lockedのを活用したRailsのデモアプリ

これは、次の教材で使われているRailsのWEBアプリに、他要素認証を活用した不正ログイン検知サービスであるLockedを導入したソースコードになります。  
・[*Ruby on Rails チュートリアル: 実例を使って Rails を学ぼう*](http://railstutorial.jp/)　[Michael Hartl](http://www.michaelhartl.com/) 著  
・[元のOSSとなっているリポジトリ](https://github.com/yasslab/sample_apps/tree/master/5_1_2/ch14) by [yasslab](https://github.com/yasslab)

## ライセンス

・[Ruby on Rails チュートリアル](http://railstutorial.jp/)内にあるすべてのソースコードはMIT ライセンスと Beerware ライセンスのもとに公開されています。詳細は [LICENSE.md](LICENSE.md) をご覧ください。  
・yasslab氏によるチャプター毎のソースコードは[こちら](https://github.com/yasslab/sample_apps/tree/master/5_1_2/ch14)  
・LockedのRuby gemはこちらを参照ください。[locked-ruby](https://github.com/OnetapInc/locked-ruby)


## ステージングで動かすには
### 診断モード
app/views/layouts/application.html.erb
  ステージングのcdnをun-comment-out
app/helpers/application_helper.rb
```:clientKey, sesucreSaltを変更
  def clientKey
    '972e0bf855e95b36cd6c832e4de5'
  end

  def secureSalt
    '45770fd6be933cb220f7f6630ccb6007'
  end
```
## 認証モード
config/initializers/locked-rb.rb
```:add
config.host = 'stg.locked.jp'
config.port = 443
config.api_key = YOUR_API_KEY
// docker-composeをrestart
```
docker-compose.yml
```:comment-out
  DOCKER_USE: 1
  LOCKED_RUBY_DEV_MODE: 'on'
```

## 動作確認方法 なにこれ

このアプリケーションを動かす場合は、まずはリポジトリを手元にクローンしてください。
その後、次のコマンドで必要になる RubyGems をインストールします。

```
$ bundle install --without production
```

その後、データベースへのマイグレーションを実行します。

```
$ rails db:migrate
```

最後に、テストを実行してうまく動いているかどうか確認してください。

```
$ rails test
```

テストが無事に通ったら、Railsサーバーを立ち上げる準備が整っているはずです。

```
$ rails server
```
