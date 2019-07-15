# Lockedのを活用したRailsのデモアプリ

これは、次の教材で使われているRailsのWEBアプリに、他要素認証を活用した不正ログイン検知サービスであるLockedを導入したソースコードになります。  
・[*Ruby on Rails チュートリアル: 実例を使って Rails を学ぼう*](http://railstutorial.jp/)　[Michael Hartl](http://www.michaelhartl.com/) 著  
・[元のOSSとなっているリポジトリ](https://github.com/yasslab/sample_apps/tree/master/5_1_2/ch14) by [yasslab](https://github.com/yasslab)

## ライセンス

・[Ruby on Rails チュートリアル](http://railstutorial.jp/)内にあるすべてのソースコードはMIT ライセンスと Beerware ライセンスのもとに公開されています。詳細は [LICENSE.md](LICENSE.md) をご覧ください。  
・yasslab氏によるチャプター毎のソースコードは[こちら](https://github.com/yasslab/sample_apps/tree/master/5_1_2/ch14)  
・LockedのRuby gemはこちらを参照ください。[locked-ruby](https://github.com/OnetapInc/locked-ruby)


## 使い方

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
