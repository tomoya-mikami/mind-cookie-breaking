# 画像分割アプリケーション

具体的なタスクの発行の仕方は[cookie-cylog](https://github.com/crowd4u/cookie-cylog)のリポジトリを見てください

## 準備するもの

- docker-engine
- docker-compose

## システム仕様

すべてdockerを使用して準備

- ruby : 2.5.1
- ruby on rails : 5.2
- mysql : 5.7
- redis : 5

## 初期設定

1. .env-sampleをコピーして.envを作成, ()のついている項目を自由に埋める
2. ```docker-compose build``` でbundle install
3. ```docker-compose up``` で起動する(必ず.envファイルの設定を先に行うこと)
4. ```docker-compose exec web rails db:migrate```, ```docker-compose exec web rails db:seed``` で初期化

## よく使うコマンド
- ```docker-compose up -d``` 起動 -dでデーモン化
- ```docker-compose down``` 停止
- ```docker-compose exec サービス名 シェルコマンド``` サービス名のコンテナ内でシェルコマンドを実行 railsコマンドも同様

## サービス名
- web : railsアプリケーション
- mysql : mysqlサーバー
- redis : redisサーバー

## 管理画面 (/admin)

各プロジェクトを管理する画面. .envで設定したメールアドレスとパスワードでログイン. プロジェクトの作成及び編集は基本この画面から行う

## sidekiq 管理画面 (/admin/sidekiq)

バックグラウンド処理の実行状況を確認する画面. 失敗した処理のエラー内容の確認, 再実行もここから行う

## モデル

- project

|name           |type     |null   |default  |description                       |
|---------------|---------|-------|---------|----------------------------------|
|name           |string   |false  |         |プロジェクトネーム                   |
|estimate_url   |string   |false  |         |Crowd4UのインサートAPIのエンドポイント |
|auth_name      |string   |false  |         |認証用ユーザーネーム                  |
|auth_password  |string   |false  |         |認証用パスワード                     |
|vertical       |intger   |false  |         |縦の分割数                          |
|horizontal     |intger   |false  |         |横の分割数                          |

- source

|name                |type     |null   |default  |description                       |
|--------------------|---------|-------|---------|----------------------------------|
|name                |string   |false  |         |画像名                             |
|uuid                |string   |false  |         |画像用uuid                         |
|project (project_id)|intger   |false  |         |プロジェクト                        |
|status              |string   |false  |         |判定結果の2次元配列をjson形式で保存    |
