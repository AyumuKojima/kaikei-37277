require 'rails_helper'

RSpec.describe "categoryの作成", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @category = FactoryBot.build(:category)
    @year = Date.today.year
    @month = Date.today.month
  end

  context 'category作成ができる時' do
    it '正しい情報を入力すれば、categoryが作成できる' do
      # ユーザー認証を通過
      basic_pass(root_path)
      # ログインする
      sign_in(@user)
      # カレンダー表示画面にカテゴリー一覧表示画面へのボタンが存在する
      expect(page).to have_content("カテゴリー")
      # カテゴリー一覧表示画面に遷移する
      click_on("カテゴリー")
      expect(current_path).to eq(year_month_categories_path(@year, @month))
      # カテゴリーを作成するためのフォームが存在する
      expect(page).to have_content("新規カテゴリー")
      # フォームに適切な情報を入力する
      fill_in 'Title', with: @category.title
      find("option[value='#{@category.color_id}']").select_option
      # submitボタンをクリックすると、Categoryモデルのカウント数が１増える
      expect{
        click_on("カテゴリーを追加する")
      }.to change { Category.count }.by(1)
      # カテゴリー一覧画面が表示されている
      expect(current_path).to eq(year_month_categories_path(@year, @month))
      # 画面には先ほど作成したカテゴリーのTitleが表示されている
      expect(page).to have_content(@category.title)
    end
  end
  context 'categoryが作成できない時' do
    it '不適な情報を入力するとcategoryが作成できない' do
      # ユーザー認証を通過
      basic_pass(root_path)
      # ログインする
      sign_in(@user)
      # カテゴリー一覧表示画面に遷移する
      visit year_month_categories_path(@year, @month)
      # フォームに不適な情報を入力する
      fill_in 'Title', with: ""
      # submitボタンを押してもCategoryモデルのカウント数が変動しない
      expect{
        click_on("カテゴリーを追加する")
      }.to change { Category.count }.by(0)
      # 画面にはエラーメッセージが表示されている
      expect(page).to have_content("Titleを入力してください")
      expect(page).to have_content("Colorを選択してください")
    end
  end
end

RSpec.describe "categoryの編集", type: :system do
  before do
    @category = FactoryBot.create(:category)
    @edit_category = FactoryBot.build(:category)
    @year = Date.today.year
    @month = Date.today.month
    ActionController::Base.allow_forgery_protection = true
  end

  after do
    ActionController::Base.allow_forgery_protection = false
  end

  context 'category編集ができる時' do
    it '適切な情報を入力するとcategoryが編集できる' do
      # ユーザー認証を通過
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # カテゴリー一覧表示画面に遷移する
      visit year_month_categories_path(@year, @month)
      # カテゴリー一覧表示画面には詳細ページへのボタンが存在する
      expect(page).to have_content('詳細')
      # カテゴリー詳細ページへ遷移する
      click_on('詳細')
      expect(current_path).to eq(year_month_category_path(@year, @month, @category.id))
      # 詳細ページには編集フォームを表示させるためのボタンが存在する
      expect(page).to have_content('編集')
      # 編集ボタンをクリックすると、編集フォームが出現する
      find("p[id='category-edit-btn']").click
      expect(page).to have_content('カテゴリーを編集')
      # 詳細フォームに適切な値を入力する
      fill_in 'Title', with: ""
      fill_in 'Title', with: @edit_category.title
      find("option[value='#{@edit_category.color_id}']").select_option
      # submitボタンを押してもCategoryモデルのカウント数は変動しない
      expect{
        click_on('カテゴリーを編集する')
      }.to change { Category.count }.by(0)
      # 詳細ページが表示されている
      expect(current_path).to eq(year_month_category_path(@year, @month, @category.id))
      # 詳細ページには先ほど編集したカテゴリーの情報が表示されている
      expect(page).to have_content(@edit_category.title)
    end
  end
  context 'categoryが編集できない時' do
    it '不適な情報を入力するとcategoryが保存できない' do
      # ユーザー認証を通過
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 編集フォームを表示させる
      find("p[id='category-edit-btn']").click
      expect(page).to have_content('カテゴリーを編集')
      # フォームに不適な情報を入力する
      fill_in 'Title', with: ""
      find("option[value='0']").select_option
      # submitボタンを押してもCategoryモデルのカウント数は変動しない
      expect{
        click_on('カテゴリーを編集する')
      }.to change { Category.count }.by(0)
      # 詳細ページが表示されている
      expect(current_path).to eq(year_month_category_path(@year, @month, @category.id))
      # 詳細ページに表示されているカテゴリーの情報が変化していない
      expect(page).to have_content(@category.title)
      expect(page).to have_no_content(@edit_category.title)
      # エラーメッセージが表示されている
      expect(page).to have_content("Titleを入力してください")
      expect(page).to have_content("Colorを選択してください")
    end
  end
end

RSpec.describe "categoryの削除", type: :system do
  before do
    @category = FactoryBot.create(:category)
    @year = Date.today.year
    @month = Date.today.month
  end

  context 'category削除ができる時' do
    it '削除ボタンを押すとcategoryが削除できる' do
      # ユーザー認証を通過
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 詳細画面にはカテゴリー削除のためのボタンが存在する
      expect(page).to have_content("削除")
      # 削除ボタンをクリックすると、カテゴリー情報内の編集ボタンと削除ボタンが消え、注意メッセージと新しい削除ボタンが表示されている
      find("a[id='category-delete-btn']").click
      expect(page).to have_no_selector("#category-edit-btn")
      expect(page).to have_no_selector("#category-delete-btn")
      expect(page).to have_content("このカテゴリーを削除しますか？")
      expect(page).to have_content("カテゴリーを削除すると、このカテゴリーに紐付いたすべての支出情報が削除されます。")
      expect(page).to have_content("削除したくない支出がある場合、支出を編集して別のカテゴリーに設定しましょう。")
      expect(page).to have_selector("#category-destroy-complete-btn")
      # 削除ボタンをクリックすると、Categoryモデルのカウント数が１減少する
      expect{
        find("a[id='category-destroy-complete-btn']").click
      }.to change { Category.count }.by(-1)
      # カテゴリー一覧表示画面に遷移している
      expect(current_path).to eq(year_month_categories_path(@year, @month))
      # 削除したカテゴリーの情報が表示されていない
      expect(page).to have_no_content(@category.title)
    end
  end
  context 'categoryを削除しない場合' do
    it '削除画面でキャンセルボタンを押すとcategoryは削除されない' do
      # ユーザー認証を通過
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 削除ボタンをクリックするとキャンセルボタンが表示されている
      find("a[id='category-delete-btn']").click
      expect(page).to have_selector("#destroy-cancel-btn")
      # キャンセルボタンをクリックしてもCategoryモデルのカウント数が変動しない
      expect{
        find("a[id='destroy-cancel-btn']").click
      }.to change { Category.count }.by(0)
      # 詳細画面に遷移している
      expect(current_path).to eq(year_month_category_path(@year, @month, @category.id))
      # カテゴリーの情報が表示されている
      expect(page).to have_content(@category.title)
    end
  end
end
