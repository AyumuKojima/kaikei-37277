require 'rails_helper'

RSpec.describe Category, type: :model do
  before do
    @category = FactoryBot.build(:category)
  end

  describe 'カテゴリーの保存' do
    context 'カテゴリーが保存できる時' do
      it '正しい情報を入力すればカテゴリーが保存できる' do
        expect(@category).to be_valid
      end
    end
    context 'カテゴリーが保存できない時' do
      it 'タイトルが空なら保存できない' do
        @category.title = ""
        @category.valid?
        expect(@category.errors.full_messages).to include("Titleを入力してください")
      end
      it 'タイトルが11文字以上なら保存できない' do
        @category.title = "アイウエオカキクケコサ"
        @category.valid?
        expect(@category.errors.full_messages).to include("Titleは10文字以内で入力してください")
      end
      it 'カラーが選択されていない場合は保存できない' do
        @category.color_id = 0
        @category.valid?
        expect(@category.errors.full_messages).to include("Colorを選択してください")
      end
      it 'ユーザーが紐付いていない場合は保存できない' do
        @category.user = nil
        @category.valid?
        expect(@category.errors.full_messages).to include("Userを入力してください")
      end
    end
  end
end
