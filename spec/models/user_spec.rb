require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context 'ユーザー新規登録できるとき' do
      it '正しい情報を入力すれば、ユーザー新規登録ができる' do
        expect(@user).to be_valid
      end
    end
    context 'ユーザー新規登録ができないとき' do
      it 'ニックネームが空だと新規登録できない' do
        @user.nickname = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Nicknameを入力してください")
      end
      it 'メールアドレスが空だと新規登録できない' do
        @user.email = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Emailを入力してください")
      end
      it 'メールアドレスに@が入っていないと新規登録できない' do
        @user.email = "abcdef"
        @user.valid?
        expect(@user.errors.full_messages).to include("Emailは不正な値です")
      end
      it '重複したメールアドレスでは新規登録できない' do
        another_user = FactoryBot.create(:user)
        @user.email = another_user.email
        @user.valid?
        expect(@user.errors.full_messages).to include("Emailはすでに存在します")
      end
      it 'パスワードが空だと新規登録できない' do
        @user.password = ""
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include("Passwordを入力してください")
      end
      it 'パスワードが5文字以下では新規登録できない' do
        @user.password = "abcde"
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include("Passwordは6文字以上で入力してください")
      end
      it 'パスワードが129文字以上では新規登録できない' do
        @user.password = Faker::Internet.password(min_length: 129)
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include("Passwordは128文字以内で入力してください")
      end
      it 'パスワードと確認用パスワードが一致していないと新規登録できない' do
        @user.password = Faker::Internet.password
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmationとPasswordの入力が一致しません")
      end
    end
  end
end
