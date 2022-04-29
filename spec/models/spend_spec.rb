require 'rails_helper'

RSpec.describe Spend, type: :model do
  before do
    @spend = FactoryBot.build(:spend)
  end

  describe '支出情報の保存' do
    context '支出が保存できるとき' do
      it 'すべての情報が正しく入力されていれば支出が保存できる' do
        expect(@spend).to be_valid
      end
      it 'メモが空でも保存できる' do
        @spend.memo = ""
        expect(@spend).to be_valid
      end
    end
    context '支出が保存できないとき' do
      it '金額が空では保存できない' do
        @spend.money = ""
        @spend.valid?
        expect(@spend.errors.full_messages).to include("Moneyを入力してください")
      end
      it '金額がひらがなでは保存できない' do
        @spend.money = "あいうえお"
        @spend.valid?
        expect(@spend.errors.full_messages).to include("Moneyは数値で入力してください")
      end
      it '金額がカタカナでは保存できない' do
        @spend.money = "アイウエオ"
        @spend.valid?
        expect(@spend.errors.full_messages).to include("Moneyは数値で入力してください")
      end
      it '金額が漢字なら保存できない' do
        @spend.money = "亜井雨江尾"
        @spend.valid?
        expect(@spend.errors.full_messages).to include("Moneyは数値で入力してください")
      end
      it '金額がアルファベットなら保存できない' do
        @spend.money = "aiueo"
        @spend.valid?
        expect(@spend.errors.full_messages).to include("Moneyは数値で入力してください")
      end
      it '金額が0円なら保存できない' do
        @spend.money = 0
        @spend.valid?
        expect(@spend.errors.full_messages).to include("Moneyは1以上の値にしてください")
      end
      it '金額が100000000円以上なら保存できない' do
        @spend.money = "100000000"
        @spend.valid?
        expect(@spend.errors.full_messages).to include("Moneyは99999999以下の値にしてください")
      end
      it 'メモが201文字以上なら保存できない' do
        @spend.memo = Faker::Lorem.characters(number: 201)
        @spend.valid?
        expect(@spend.errors.full_messages).to include("Memoは200文字以内で入力してください")
      end
      it 'カテゴリーが紐付いていなければ保存できない' do
        @spend.category = nil
        @spend.valid?
        expect(@spend.errors.full_messages).to include("Categoryを入力してください")
      end
      it 'ユーザーが紐付いていなければ保存できない' do
        @spend.user = nil
        @spend.valid?
        expect(@spend.errors.full_messages).to include("Userを入力してください")
      end
    end
  end
end
