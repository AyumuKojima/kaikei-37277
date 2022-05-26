# README

## アプリケーション名
Spend manager
('kaikei-37277' はgit-hubのレポジトリ名です。)

## アプリケーション概要
このアプリは支出管理アプリです。
- 各月の各支出と合計支出額を管理できる。
- カテゴリ別に支出を管理できる。

## URL
https://kaikei-37277.herokuapp.com/

## テスト用アカウント
Basic認証パスワード: 2222
Basic認証ID: admin

## 利用方法
### カテゴリー登録・編集・削除
- サイドバーのボタンからカテゴリ一覧画面に遷移する
- 画面右のフォームから新規カテゴリーを登録する
- 登録したカテゴリーの枠にある「詳細」ボタンから詳細ページに遷移する
- カテゴリー詳細ページからカテゴリーの編集・削除が可能

### 支出登録・編集・削除
- サイドバーの「支出を入力」ボタンからカレンダー画面に遷移する
- 登録した支出の情報（日付・金額・カテゴリー・メモ）を入力し、登録する
- 日付は、登録したい日のカレンダーの枠をクリックすることで自動入力される
- カレンダー右上のボタンから、１ヶ月の全支出の一覧を表示できる
- 一覧表示画面の支出情報をクリックすることで支出の編集・削除が可能
- 支出の編集・削除はカテゴリー詳細画面からも行うことができる

## アプリケーションを作成した背景
自分自身の実体験として、普段の生活の中で自分がどんなことにどれくらいの支出をしているかが把握できずに、つい使い過ぎてしまうという問題があった。
カテゴリー別に支出を管理し、どのカテゴリーの中で自分がいくら支出をしているのかを自動的に計算できれば、無駄遣いが減り、より効率良くお金と向き合えると考えた。

## 洗い出した要件
要件定義シート
https://docs.google.com/spreadsheets/d/1sPKIbz8YJY-vutaZijvYMx5DmXwDwRzJhguakv2usT8/edit?usp=sharing

## 実装予定の機能
- 収入管理機能
- グラフ作成機能
- 固定費管理機能

## データベース設計
![ER](https://user-images.githubusercontent.com/81469999/170502741-7362ed15-1337-47bb-90ae-6c5f6f0a5cea.png)

### users テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| nickname           | string | null: false               |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |

#### Association

- has_many: spends
- has_many: categories
- has_many: fixes

### spends テーブル

| Column   | Type       | Options                        |
| -------- | ---------- | ------------------------------ |
| money    | integer    | null: false                    |
| day      | date       | null: false                    |
| memo     | string     |                                |
| user     | references | null: false, foreign_key: true |
| category | references | null: false, foreign_key: true |

#### Association

- belongs_to: user
- belongs_to: category

### categories テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| title  | string     | null: false                    |
| user   | references | null: false, foreign_key: true |

#### Association

- belongs_to: user
- has_many: spends

### fixes テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| name   | string     | null: false                    |
| money  | integer    | null: false                    |
| user   | references | null: false, foreign_key: true |

#### Association

- belongs_to: user

## 開発環境
- ruby on rails 6.0.0
- javascript
- MySQL
- HTML
- CSS