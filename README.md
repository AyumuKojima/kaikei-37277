# README

# データベース設計

## users テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| nickname           | string | null: false               |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |

### Association

- has_many: spends
- has_many: categories
- has_many: fixes

## spends テーブル

| Column   | Type       | Options                        |
| -------- | ---------- | ------------------------------ |
| money    | integer    | null: false                    |
| day      | date       | null: false                    |
| memo     | string     |                                |
| user     | references | null: false, foreign_key: true |
| category | references | null: false, foreign_key: true |

### Association

- belongs_to: user
- belongs_to: category

## categories テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| title  | string     | null: false                    |
| user   | references | null: false, foreign_key: true |

### Association

- belongs_to: user
- has_many: spends

## fixes テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| name   | string     | null: false                    |
| money  | integer    | null: false                    |
| user   | references | null: false, foreign_key: true |

### Association

- belongs_to: user