require 'rails_helper'

RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
    @year = Date.today.year
    @month = Date.today.month
  end

  context 'ユーザー新規登録できる' do
    it '正しい情報を入力すれば、新規登録できる' do
      # トップページに移動する
      basic_pass(root_path)
      # トップページにはサインアップ画面へ遷移するボタンが存在する
      expect(page).to have_content('Sign up')
      # サインアップ画面へ遷移する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in "Nickname", with: @user.nickname
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      fill_in "Password confirmation", with: @user.password_confirmation
      # サインアップボタンを押すと、ユーザーモデルのカウントが１上がる
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(1)
      # カレンダー表示画面に遷移している
      expect(current_path).to eq(year_month_spends_path(@year, @month))
      # サインアップ画面へ遷移するボタンやログイン画面へ遷移するボタンが存在しない
      expect(page).to have_no_content('Sign up')
      expect(page).to have_no_content('Log in')
    end
  end
  context 'ユーザー新規登録できない' do
    it '不適な情報を入力すれば、新規登録できずにトップページに戻ってくる' do
      # トップページへ遷移する
      basic_pass(root_path)
      # トップページにはサインアップ画面へ遷移するボタンが存在する
      expect(page).to have_content('Sign up')
      # サインアップ画面へ遷移する
      visit new_user_registration_path
      # 不適切なユーザー情報を入力する
      fill_in "Nickname", with: ""
      fill_in "Email", with: ""
      fill_in "Password", with: ""
      fill_in "Password confirmation", with: ""
      # サインアップボタンを押してもユーザーモデルのカウントが上がらない
      expect{
        find('input[name="commit"]').click
      }.to change{ User.count }.by(0)
      #binding.pry
      # 新規登録画面に留まっている
      expect(current_path).to eq(user_registration_path)
    end
  end
end

RSpec.describe 'ユーザーログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @year = Date.today.year
    @month = Date.today.month
  end

  context 'ログインができる時' do
    it '正しい情報を入力すればログインできる' do
      # トップページに遷移する
      basic_pass(root_path)
      # フォームに情報を入力する
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      # ログインボタンをクリックすると、カレンダー表示画面に遷移する
      find('input[name="commit"]').click
      expect(current_path).to eq(year_month_spends_path(@year, @month))
    end
  end

  context 'ログインできない時' do
    it '誤った情報を入力すればログインできない' do
      # トップページに遷移する
      basic_pass(root_path)
      # 未登録のユーザー情報を入力する
      another_user = FactoryBot.build(:user)
      fill_in 'Email', with: another_user.email
      fill_in 'Password', with: another_user.password
      # ログインボタンをクリックしても、ログイン画面に留まっている
      find('input[name="commit"]').click
      expect(current_path).to eq(user_session_path)
    end
  end
end

RSpec.describe 'ユーザーログアウト', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @year = Date.today.year
    @month = Date.today.month
  end

  it 'ログインしたユーザーはログアウトできる' do
    # ログインする
    basic_pass(root_path)
    sign_in(@user)
    # サイドバーのユーザーボタンをクリックすると、ログアウトボタンが表示される
    find('img[id="user-btn"]').click
    expect(page).to have_content("ログアウト")
    # ログアウトボタンをクリックするとログアウトし、ログイン画面に遷移する。
    click_on('ログアウト')
    expect(current_path).to eq(user_session_path)
  end
end
