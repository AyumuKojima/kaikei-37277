class Color < AvtiveHash::Base
  self.data = [
    {id: 0, name: "--"},
    {id: 1, name: "あか"},
    {id: 2, name: "しゅいろ"},
    {id: 3, name: "ワインレッド"},
    {id: 4, name: "オレンジ"},
    {id: 5, name: "きいろ"},
    {id: 6, name: "ライムイエロー"},
    {id: 7, name: "みどり"},
    {id: 8, name: "きみどり"},
    {id: 9, name: "モスグリーン"},
    {id: 10, name: "あお"},
    {id: 11, name: "みずいろ"},
    {id: 12, name: "ぐんじょういろ"},
    {id: 13, name: "あいいろ"},
    {id: 14, name: "ナイルブルー"},
    {id: 15, name: "ピンク"},
    {id: 16, name: "むらさき"},
    {id: 17, name: "あかむらさき"},
    {id: 18, name: "チリアンパープル"},
    {id: 19, name: "くろ"},
    {id: 20, name: "グレー"},
    {id: 21, name: "シルバーグレー"},
    {id: 22, name: "ちゃいろ"},
    {id: 23, name: "おうどいろ"}
    {id: 24, name: "チョコレート"},
    {id: 25, name: "テラコッタ"}
  ]

  include ActiveHash::Associations
  has_many :categories
end