class Color < ActiveHash::Base
  self.data = [
    {id: 0,  name: "色を選択してください。", rgb: [0,164,150]},
    {id: 1,  name: "あか", rgb: [255,0,0]},
    {id: 2,  name: "マゼンタ", rgb: [228,0,127]},
    {id: 3,  name: "ワインレッド", rgb: [147,46,68]},
    {id: 4,  name: "オレンジ", rgb: [255,165,0]},
    {id: 5,  name: "オリーブ", rgb: [114,100,10]},
    {id: 6,  name: "きいろ", rgb: [255,217,0]},
    {id: 7,  name: "みどり", rgb: [62,179,112]},
    {id: 8,  name: "きみどり", rgb: [184,210,0]},
    {id: 9,  name: "ふかみどり", rgb: [0,88,45]},
    {id: 10, name: "ピーコックグリーン", rgb: [0,164,150]},
    {id: 11, name: "あお", rgb: [0,149,217]},
    {id: 12, name: "そらいろ", rgb: [100,188,199]},
    {id: 13, name: "ぐんじょういろ", rgb: [78,103,176]},
    {id: 14, name: "あいいろ", rgb: [15,87,121]},
    {id: 15, name: "かちいろ", rgb: [85,87,108]},
    {id: 16, name: "ピンク", rgb: [240,145,153]},
    {id: 17, name: "むらさき", rgb: [142,72,152]},
    {id: 18, name: "あかむらさき", rgb: [234,96,158]},
    {id: 19, name: "チリアンパープル", rgb: [149,64,101]},
    {id: 20, name: "くろ", rgb: [19,0,18]},
    {id: 21, name: "グレー", rgb: [125,125,125]},
    {id: 22, name: "シルバーグレー", rgb: [175,175,176]},
    {id: 23, name: "ちゃいろ", rgb: [141,80,37]},
    {id: 24, name: "おうどいろ", rgb: [195,144,67]},
    {id: 25, name: "チョコレート", rgb: [97,44,22]},
    {id: 26, name: "テラコッタ", rgb: [190,109,85]}
  ]

  include ActiveHash::Associations
  has_many :categories
end