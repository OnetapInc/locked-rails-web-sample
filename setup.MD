### ゴール
http://localhost:3232 が開く
アカウントでログインができる

### セットアップ
- githubからクローン https://github.com/OnetapInc/locked-rails-web-sample
- docker-compose build
- docker-compose run --rm sample_app bundle
    - 以下エラーが出たら、武田さんのアカウントでログイン
    - <img title='image.png' src='/attachments/87c0727e-c82b-482a-8ed8-54cfea5f89f6' width="2880" data-meta='{"width":2880,"height":130}'>
- docker-compose up
- docker-compose run --rm sample_app bundle install
- docker-compose run --rm sample_app bundle exec rails db:migrate && bundle exec rails db:seed
- http://localhost:3232 を開く
- パスワードをリセットする
- docker-composeのコンソールにパスワードリセットのリンクが表示されるので、アクセス
- <img title='image.png' src='/attachments/feb7be9f-e609-49ce-b5c9-82efc5d2c845' width="1426" data-meta='{"width":1426,"height":220}'>
    - 上記では http://localhost:3232/password_resets/HAWZhp_4DTL2SQ3hSGHswA/edit?email=kajirikajiri%40gmail.com
- パスワードをリセットすることでログインできるユーザーが作成できる
