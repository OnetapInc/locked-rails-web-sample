# Lockedのを活用したRailsのデモアプリ

これは、次の教材で使われているRailsのWEBアプリに、他要素認証を活用した不正ログイン検知サービスであるLockedを導入したソースコードになります。  
・[*Ruby on Rails チュートリアル: 実例を使って Rails を学ぼう*](http://railstutorial.jp/)　[Michael Hartl](http://www.michaelhartl.com/) 著  
・[元のOSSとなっているリポジトリ](https://github.com/yasslab/sample_apps/tree/master/5_1_2/ch14) by [yasslab](https://github.com/yasslab)

## ライセンス

・[Ruby on Rails チュートリアル](http://railstutorial.jp/)内にあるすべてのソースコードはMIT ライセンスと Beerware ライセンスのもとに公開されています。詳細は [LICENSE.md](LICENSE.md) をご覧ください。  
・yasslab氏によるチャプター毎のソースコードは[こちら](https://github.com/yasslab/sample_apps/tree/master/5_1_2/ch14)  
・LockedのRuby gemはこちらを参照ください。[locked-ruby](https://github.com/OnetapInc/locked-ruby)


## 動作確認方法

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

## Lockedの導入方法
LockedをRailsのWEBアプリに導入する場合、以下の手順が必要です
#### セッション作成部分にauthenticateメソッドを入れる
```ruby
begin
 result = locked.authenticate(
   event: '$login.attempt',
   user_id: "user#{user.id}",
   user_ip: request.remote_ip,
   user_agent: request.user_agent,
   email: user.email,
   callback_url: 'http://0.0.0.0:3000/load'
 )
rescue Locked::Error => e
 puts e.message
end

case result[:data][:action]
when 'allow'
when 'verify'
when 'deny'
end
```

#### authenticateにより認証が必要だった場合のviewを用意する
verify.html.erbを用意

#### 認証を識別するため、lockedからの一意な認証コードを保存できるようにカラムを追加します
```ruby
class AddLockedTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :locked_token, :string
  end
end
```

#### lockedからの一意な認証コードを保存させます
```ruby
case result[:data][:action]
when 'allow'
when 'verify'
  user.update!(locked_token: result[:data][:verify_token])
  render 'verify'
when 'deny'
end
```

#### 認証後のコールバックページを用意します
```ruby
# GET /load
def load
  user = User.find_by(locked_token: params[:token])
  if user && user.activated?
    log_in user
    remember(user)
    redirect_to user
  else
    flash[:warning] = "アカウント情報の読み込みに失敗しました"
    redirect_to root_url
  end
end
```
