require 'rails_helper'

def regist_spend(spend, category)
  expect(page).to have_selector(".spend-input-form")
  fill_in 'Money', with: spend.money
  find("select[id='category_id']").find("option[value='#{category.id}']").select_option
  fill_in 'Memo', with: spend.memo
  expect{
    wait_for_ajax(5) do
      find("input[name='commit']").click
    end
  }.to change { Spend.count }.by(1)
end

RSpec.describe "支出の登録", type: :system, :js => true do
  before do
    @category = FactoryBot.create(:category)
    @spend = FactoryBot.build(:spend)
    @year = Date.today.year
    @month = Date.today.month
    @day = Date.today.day
    ActionController::Base.allow_forgery_protection = true
  end

  after do
    ActionController::Base.allow_forgery_protection = false
  end

  context '支出が登録できる時' do
    it 'すべての情報が正しく入力されていれば支出が登録できる' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # 支出登録フォームが存在する
      expect(page).to have_selector(".spend-input-form")
      # 日付のフォームには今日の日付が入力されている
      expect(page).to have_select('[day(1i)]', selected: "#{@year}")
      expect(page).to have_select('[day(2i)]', selected: "#{@month}")
      expect(page).to have_select('[day(3i)]', selected: "#{@day}")
      # money、category、memoのフォームにそれぞれ入力する
      fill_in 'Money', with: @spend.money
      find("select[id='category_id']").find("option[value='#{@category.id}']").select_option
      fill_in 'Memo', with: @spend.memo
      # submitボタンを押すと、Spendモデルのカウント数が１増える
      expect{
        wait_for_ajax(5) do
          find("input[name='commit']").click
        end
      }.to change { Spend.count }.by(1)
      # カレンダーの今日の日付の枠に入力した支出が表示されている
      expect(
        find_all('div[class="day-sum this-month-sum"]')[@day-1]['innerHTML']
      ).to eq("#{@spend.money}円")
      # ヘッダーの支出合計額に先ほど登録した支出の金額が表示されている
      expect(
        find('div[class="header"]')
      ).to have_content(@spend.money.to_s(:delimited))
      # 支出一覧表示画面へのボタンが存在する
      expect(page).to have_content("支出一覧を表示")
      # ボタンを押すと支出一覧表示画面へ遷移する
      click_on("支出一覧を表示")
      expect(current_path).to eq(year_month_path(@year, @month))
      # 先ほど登録した支出の情報が表示されている
      expect(find('div[class="contents"]')).to have_content(Date.new(@year, @month, @day).to_s)
      expect(find('div[class="contents"]')).to have_content(@category.title)
      expect(find('div[class="contents"]')).to have_content("#{@spend.money}円")
      expect(find('div[class="contents"]')).to have_content(@spend.memo)
      # カテゴリー一覧画面へ遷移する
      visit year_month_categories_path(@year, @month)
      # 先ほど登録した支出に紐付いたカテゴリーに、登録した支出の金額が表示されている
      expect(
        find('div[class="category-money-sum"]')
      ).to have_content("#{@spend.money}円")
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 先ほど登録した支出の情報が表示されている
      expect(find('div[class="contents"]')).to have_content(Date.new(@year, @month, @day).to_s)
      expect(find('div[class="contents"]')).to have_content(@category.title)
      expect(find('div[class="contents"]')).to have_content("#{@spend.money}円")
      expect(find('div[class="contents"]')).to have_content(@spend.memo)
    end
    it 'カレンダーの枠をクリックすると、その日の支出が登録できる' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # カレンダーが存在する
      expect(page).to have_selector(".calendar-main")
      # カレンダーの今月の今日以外の枠をクリックすると、枠の色が変化し、日付フォームの値が変化する
      num = Faker::Number.between(from: 0, to: 27)
      find_all(".this-month")[num].click
      wait_for_ajax(5)
      expect(find_all(".this-month")[num].style("border")).to eq({"border"=>"3px solid rgb(255, 20, 147)"})
      expect(page).to have_select('[day(1i)]', selected: "#{@year}")
      expect(page).to have_select('[day(2i)]', selected: "#{@month}")
      expect(page).to have_select('[day(3i)]', selected: "#{num+1}")
      # money、category、memoのフォームに値を入力する
      fill_in 'Money', with: @spend.money
      find("select[id='category_id']").find("option[value='#{@category.id}']").select_option
      fill_in 'Memo', with: @spend.memo
      # submitボタンを押すとSpendモデルのカウント数が１増える
      expect{
        wait_for_ajax(5) do
          find("input[name='commit']").click
        end
      }.to change { Spend.count }.by(1)
      # 先ほどクリックしたカレンダーの枠に登録した支出の金額が表示されている
      expect(find_all(".this-month")[num]).to have_content("#{@spend.money}円")
      # 支出一覧表示画面へ遷移する
      click_on("支出一覧を表示")
      expect(current_path).to eq(year_month_path(@year, @month))
      # 先ほど登録した支出の情報が表示されている
      expect(find('div[class="contents"]')).to have_content(Date.new(@year, @month, num+1).to_s)
      expect(find('div[class="contents"]')).to have_content(@category.title)
      expect(find('div[class="contents"]')).to have_content("#{@spend.money}円")
      expect(find('div[class="contents"]')).to have_content(@spend.memo)
      # カテゴリー一覧画面へ遷移する
      visit year_month_categories_path(@year, @month)
      # 先ほど登録した支出に紐付いたカテゴリーに、登録した支出の金額が表示されている
      expect(
        find('div[class="category-money-sum"]')
      ).to have_content("#{@spend.money}円")
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 先ほど登録した支出の情報が表示されている
      expect(find('div[class="contents"]')).to have_content(Date.new(@year, @month, num+1).to_s)
      expect(find('div[class="contents"]')).to have_content(@category.title)
      expect(find('div[class="contents"]')).to have_content("#{@spend.money}円")
      expect(find('div[class="contents"]')).to have_content(@spend.memo)
    end
    it '同じ日に複数の支出を登録すると、カレンダーとヘッダーに支出金額の合計が表示される' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # カレンダーの今月の枠を一つクリックする
      num = Faker::Number.between(from: 0, to: 27)
      wait_for_ajax(5) do
        find_all(".this-month")[num].click
      end
      expect(find_all(".this-month")[num].style("border")).to eq({"border"=>"3px solid rgb(255, 20, 147)"})
      expect(page).to have_select('[day(1i)]', selected: "#{@year}")
      expect(page).to have_select('[day(2i)]', selected: "#{@month}")
      expect(page).to have_select('[day(3i)]', selected: "#{num+1}")
      # 同じ日に支出を２つ登録する
      spend2 = FactoryBot.build(:spend)
      regist_spend(@spend, @category)
      regist_spend(spend2, @category)
      # ヘッダーに２つの支出の合計金額が表示されている
      sum = @spend.money + spend2.money
      expect(
        find("div[class='header']")
      ).to have_content(sum.to_s(:delimited))
      # カレンダーに２つの支出の合計金額が表示されている
      expect(
        find("div[class='calendar-main']")
      ).to have_content("#{sum}円")
    end
    it '同じカテゴリに複数の支出を登録すると、カテゴリーに支出金額の合計が表示される' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # 同じカテゴリーで支出を２つ登録する
      spend2 = FactoryBot.build(:spend)
      regist_spend(@spend, @category)
      regist_spend(spend2, @category)
      # カテゴリー一覧表示画面に遷移する
      visit year_month_categories_path(@year, @month)
      # ２つの支出の合計金額が表示されている
      sum = @spend.money + spend2.money
      expect(
        find('div[class="category-money-sum"]')
      ).to have_content("#{sum}円")
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # ２つの支出の合計金額が表示されている
      expect(
        find('div[class="category-money-sum"]')
      ).to have_content("#{sum}円")
    end
    it '別の月に支出を登録すると、今月のカレンダーおよびカテゴリーの支出合計金額には反映されない' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # 別の月に支出を入力する
      month = Faker::Number.between(from: 1, to: 6)
      if month == @month
        month = Faker::Number.between(from: 7, to: 12)
      end
      num = Faker::Number.between(from: 10, to: 20)
      find("select[id='_day_2i']").find("option[value='#{month}']").select_option
      find("select[id='_day_3i']").find("option[value='#{num}']").select_option
      regist_spend(@spend, @category)
      # ヘッダーの合計支出額の値は変動していない
      expect(find("div[class='header']")).to have_content("0")
      # カレンダーの今月の枠の表示は変化していない
      expect(find_all(".this-month")[num-1]).to have_no_content("#{@spend.money}円")
      # 今月の支出一覧画面に遷移する
      visit year_month_path(@year, @month)
      # 先ほど登録した支出の情報は表示されていない
      expect(find('div[class="show-list"]')).to have_no_content(Date.new(@year, month, num).to_s)
      expect(find('div[class="show-list"]')).to have_no_content(@category.title)
      expect(find('div[class="show-list"]')).to have_no_content("#{@spend.money}円")
      expect(find('div[class="show-list"]')).to have_no_content(@spend.memo)
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 先ほど登録した支出の情報は表示されていない
      expect(find('div[class="category-show-list"]')).to have_no_content(Date.new(@year, month, num).to_s)
      expect(find('div[class="category-show-list"]')).to have_no_content(@category.title)
      expect(find('div[class="category-show-list"]')).to have_no_content("#{@spend.money}円")
      expect(find('div[class="category-show-list"]')).to have_no_content(@spend.memo)
      # 登録した月のカレンダー表示画面には、支出の情報が表示されている
      visit year_month_spends_path(@year, month)
      expect(find("div[class='header']")).to have_content(@spend.money.to_s(:delimited))
      expect(find_all(".this-month")[num-1]).to have_content("#{@spend.money}円")
      # 登録した月の支出一覧画面には、支出の情報が表示されている
      visit year_month_path(@year, month)
      expect(find('div[class="show-list"]')).to have_content(Date.new(@year, month, num).to_s)
      expect(find('div[class="show-list"]')).to have_content(@category.title)
      expect(find('div[class="show-list"]')).to have_content("#{@spend.money}円")
      expect(find('div[class="show-list"]')).to have_content(@spend.memo)
      # 登録した月のカテゴリー詳細画面には、支出の情報が表示されている
      visit year_month_category_path(@year, month, @category.id)
      expect(find('div[class="category-show-list"]')).to have_content(Date.new(@year, month, num).to_s)
      expect(find('div[class="category-show-list"]')).to have_content(@category.title)
      expect(find('div[class="category-show-list"]')).to have_content("#{@spend.money}円")
      expect(find('div[class="category-show-list"]')).to have_content(@spend.memo)
    end
  end
  context '支出が登録できない時' do
    it '不適な入力だと支出が登録できない' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # money、category、memoのフォームにそれぞれ不適な値を入力する
      fill_in 'Money', with: ""
      find("select[id='category_id']").find("option[value='#{0}']").select_option
      # submitボタンを押してもSpendモデルのカウント数は変動しない
      expect{
        wait_for_ajax(5) do
          find("input[name='commit']").click
        end
      }.to change { Spend.count }.by(0)
      # エラーメッセージが表示されている
      expect(page).to have_content("Categoryを入力してください")
      expect(page).to have_content("Moneyを入力してください")
      expect(page).to have_content("Moneyは数値で入力してください")
      # ヘッダーの合計支出額の値は変動していない
      expect(find("div[class='header']")).to have_content(0)
      # カレンダーの今月の枠の表示は変化していない
      expect(
        find_all(".this-month")[@day-1]
      ).to have_no_content("#{@spend.money}円")
      # 支出一覧画面に遷移する
      visit year_month_path(@year, @month)
      # 支出の情報は表示されていない
      expect(find('div[class="show-list"]')).to have_no_content(Date.new(@year, @month, @day).to_s)
      expect(find('div[class="show-list"]')).to have_no_content(@category.title)
      expect(find('div[class="show-list"]')).to have_no_content("#{@spend.money}円")
      expect(find('div[class="show-list"]')).to have_no_content(@spend.memo)
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 支出の情報は表示されていない
      expect(find('div[class="category-show-list"]')).to have_no_content(Date.new(@year, @month, @day).to_s)
      expect(find('div[class="category-show-list"]')).to have_no_content(@category.title)
      expect(find('div[class="category-show-list"]')).to have_no_content("#{@spend.money}円")
      expect(find('div[class="category-show-list"]')).to have_no_content(@spend.memo)
    end
  end
end

RSpec.describe '支出の編集' do
  before do
    @category = FactoryBot.create(:category)
    @category2 = FactoryBot.build(:category)
    @category2.user = @category.user
    @category2.save
    @spend = FactoryBot.build(:spend)
    @spend2 = FactoryBot.build(:spend)
    @year = Date.today.year
    @month = Date.today.month
    @day = Date.today.day
    ActionController::Base.allow_forgery_protection = true
  end

  after do
    ActionController::Base.allow_forgery_protection = false
  end

  context '支出の編集ができる時' do
    it '支出一覧表示画面ですべての項目に正しい値を入力すれば、支出が編集できる' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # 支出を登録する
      regist_spend(@spend, @category)
      # 支出一覧表示画面に遷移する
      visit year_month_path(@year, @month)
      # 編集フォームが存在する
      expect(page).to have_selector(".spend-input-form")
      # 編集フォームにはsubmitボタンが表示されていない
      expect(find(".spend-input-form")).to have_no_selector("#spend-update-submit")
      # 登録してある支出の枠をクリックすると、支出の内容が編集フォームに入力され、編集のためのsubmitボタンが出現する
      find_all(".show-info")[0].click
      expect(
        find_all(".show-info")[0].style("border")
      ).to eq({"border"=>"3px solid rgb(255, 20, 147)"})
      expect(find(".spend-input-form")).to have_selector("#spend-update-submit")
      expect(find("input[name='money']").value).to eq("#{@spend.money}")
      expect(find("select[id='category_id']").value).to eq("#{@category.id}")
      expect(find("textarea[name='memo']").value).to eq(@spend.memo)
      # フォームの値を書き換える
      fill_in "Money", with: ""
      fill_in "Money", with: @spend2.money
      find("select[id='category_id']").find("option[value='#{@category2.id}']").select_option
      fill_in "Memo", with: ""
      fill_in "Memo", with: @spend2.memo
      # submitボタンをクリックしてもSpendモデルのカウント数が変動しない
      expect{
        wait_for_ajax(5) do
          find("input[name='commit']").click
        end
      }.to change { Spend.count }.by(0)
      # ヘッダーの合計金額の値が変動している
      expect(find("div[class='header']")).to have_content(@spend2.money.to_s(:delimited))
      # 表示してある支出情報が変化している
      expect(find('div[class="show-list"]')).to have_content(@category2.title)
      expect(find('div[class="show-list"]')).to have_content("#{@spend2.money}円")
      expect(find('div[class="show-list"]')).to have_content(@spend2.memo)
      # カレンダー表示画面に遷移する
      visit year_month_spends_path(@year, @month)
      # 支出の金額の値が変化している
      expect(
        find_all('div[class="day-sum this-month-sum"]')[@day-1]['innerHTML']
      ).to eq("#{@spend2.money}円")
      # カテゴリー一覧表示画面に遷移する
      visit year_month_categories_path(@year, @month)
      # カテゴリーの合計支出額が変化している
      expect(
        find_all('div[class="category-money-sum"]')[1]
      ).to have_content("#{@spend2.money}円")
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category2.id)
      # 表示してある支出情報が変化している
      expect(find('div[class="category-show-list"]')).to have_content(@category2.title)
      expect(find('div[class="category-show-list"]')).to have_content("#{@spend2.money}円")
      expect(find('div[class="category-show-list"]')).to have_content(@spend2.memo)
    end
    it 'カテゴリー詳細画面ですべての項目に正しい値を入力すれば、支出が編集できる' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # 支出を登録する
      regist_spend(@spend, @category)
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 編集フォームが存在する
      expect(page).to have_selector(".spend-input-form")
      # 編集フォームにはsubmitボタンが表示されていない
      expect(find(".spend-input-form")).to have_no_selector("#spend-update-submit")
      # 登録してある支出の枠をクリックすると、支出の内容が編集フォームに入力され、編集のためのsubmitボタンが出現する
      find_all(".show-info")[0].click
      expect(
        find_all(".show-info")[0].style("border")
      ).to eq({"border"=>"3px solid rgb(255, 20, 147)"})
      expect(find(".spend-input-form")).to have_selector("#spend-update-submit")
      expect(find("input[name='money']").value).to eq("#{@spend.money}")
      expect(find("select[id='category_id']").value).to eq("#{@category.id}")
      expect(find("textarea[name='memo']").value).to eq(@spend.memo)
      # 編集フォームの値を書き換える
      fill_in "Money", with: ""
      fill_in "Money", with: @spend2.money
      fill_in "Memo", with: ""
      fill_in "Memo", with: @spend2.memo
      # submitボタンをクリックしてもSpendモデルのカウント数が変動しない
      expect{
        wait_for_ajax(5) do
          find("input[name='commit']").click
        end
      }.to change { Spend.count }.by(0)
      # ヘッダーの合計金額の値が変動している
      expect(find("div[class='header']")).to have_content(@spend2.money.to_s(:delimited))
      # 表示してある支出情報が変化している
      expect(find('div[class="category-show-list"]')).to have_content("#{@spend2.money}円")
      expect(find('div[class="category-show-list"]')).to have_content(@spend2.memo)
      # カレンダー表示画面に遷移する
      visit year_month_spends_path(@year, @month)
      # 支出の金額の値が変化している
      expect(
        find_all('div[class="day-sum this-month-sum"]')[@day-1]['innerHTML']
      ).to eq("#{@spend2.money}円")
      # カテゴリー一覧表示画面に遷移する
      visit year_month_categories_path(@year, @month)
      # カテゴリーの合計支出額が変化している
      expect(
        find_all('div[class="category-money-sum"]')[0]
      ).to have_content("#{@spend2.money}円")
      # 支出一覧画面に遷移する
      visit year_month_path(@year, @month)
      # 表示してある支出情報の金額が変化している
      expect(find('div[class="show-list"]')).to have_content("#{@spend2.money}円")
      expect(find('div[class="show-list"]')).to have_content(@spend2.memo)
    end
    it '今月の違う日付に編集すると支出が表示されるカレンダーの枠の場所が変化する' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # 支出を登録する
      regist_spend(@spend, @category)
      # 支出一覧表示画面に遷移する
      visit year_month_path(@year, @month)
      # 登録してある支出の枠をクリックする
      find_all(".show-info")[0].click
      # 日付の日にちの欄を変更する
      day2 = Faker::Number.between(from: 1, to: 27)
      find("select[id='_day_3i']").find("option[value='#{day2}']").select_option
      # submitボタンをクリックしてもSpendモデルのカウント数が変動しない
      expect{
        wait_for_ajax(5) do
          find("input[name='commit']").click
        end
      }.to change { Spend.count }.by(0)
      # 表示してある支出情報の日付が変化している
      expect(find('div[class="show-list"]')).to have_content(Date.new(@year, @month, day2).to_s)
      # カレンダー表示画面に遷移する
      visit year_month_spends_path(@year, @month)
      # 支出の日付が変化している
      expect(
        find_all('div[class="day-sum this-month-sum"]')[day2-1]['innerHTML']
      ).to eq("#{@spend.money}円")
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 表示してある支出情報の日付が変化している
      expect(find('div[class="category-show-list"]')).to have_content(Date.new(@year, @month, day2).to_s)
    end
    it '違うカテゴリーに編集すると支出が表示されるカテゴリーが変化する' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # 支出を登録する
      regist_spend(@spend, @category)
      # カテゴリー詳細表示画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 登録してある支出の枠をクリックする
      find_all(".show-info")[0].click
      # カテゴリーを変更する
      find("select[id='category_id']").find("option[value='#{@category2.id}']").select_option
      # submitボタンをクリックしてもSpendモデルのカウント数が変動しない
      expect{
        wait_for_ajax(5) do
          find("input[name='commit']").click
        end
      }.to change { Spend.count }.by(0)
      # 支出情報の表示が消えている
      expect(page).to have_no_selector(".show-info")
      # 別のカテゴリーの詳細画面に支出情報が表示されている
      visit year_month_category_path(@year, @month, @category2.id)
      expect(find('div[class="category-show-list"]')).to have_content(@category2.title)
      expect(find('div[class="category-show-list"]')).to have_content("#{@spend.money}円")
      expect(find('div[class="category-show-list"]')).to have_content(@spend.memo)
      # カテゴリー一覧表示画面に遷移すると、カテゴリーの合計支出額が変化している
      visit year_month_categories_path(@year, @month)
      expect(
        find_all('div[class="category-money-sum"]')[0]
      ).to have_content("0円")
      expect(
        find_all('div[class="category-money-sum"]')[1]
      ).to have_content("#{@spend.money}円")
      # 支出一覧画面に遷移する
      visit year_month_path(@year, @month)
      # 表示してある支出情報のカテゴリーが変化している
      expect(find('div[class="show-list"]')).to have_content(@category2.title)
    end
    it '違う月の日付に編集すると、今月の支出一覧画面やカテゴリー表示画面には支出情報が表示されなくなる' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # 支出を登録する
      regist_spend(@spend, @category)
      # 支出一覧表示画面に遷移する
      visit year_month_path(@year, @month)
      # 登録してある支出の枠をクリックする
      find_all(".show-info")[0].click
      # 日付の欄に別の月の日付を入力する
      month = Faker::Number.between(from: 1, to: 6)
      if month == @month
        month = Faker::Number.between(from: 7, to: 12)
      end
      day2 = Faker::Number.between(from: 10, to: 20)
      find("select[id='_day_2i']").find("option[value='#{month}']").select_option
      find("select[id='_day_3i']").find("option[value='#{day2}']").select_option
      # submitボタンをクリックしてもSpendモデルのカウント数が変動しない
      expect{
        wait_for_ajax(5) do
          find("input[name='commit']").click
        end
      }.to change { Spend.count }.by(0)
      # 編集した支出情報が表示されていない
      expect(page).to have_no_selector(".show-info")
      # カテゴリー一覧表示画面に遷移する
      visit year_month_categories_path(@year, @month)
      # カテゴリーの合計支出額が変化している
      expect(
        find_all('div[class="category-money-sum"]')[0]
      ).to have_content("0円")
      # カテゴリー詳細画面に遷移すると、編集した支出情報が表示されていない
      visit year_month_category_path(@year, @month, @category.id)
      expect(page).to have_no_selector(".show-info")
      # 編集した月のカレンダー表示画面に支出の情報が表示されている
      visit year_month_spends_path(@year, month)
      expect(find("div[class='header']")).to have_content(@spend.money.to_s(:delimited))
      expect(
        find_all(".this-month")[day2-1]
      ).to have_content("#{@spend.money}円")
      # 編集した月の支出一覧表示画面に支出の情報が表示されている
      visit year_month_path(@year, month)
      expect(find_all(".show-info")[0]).to have_content(@category.title)
      expect(find_all(".show-info")[0]).to have_content("#{@spend.money}円")
      expect(find_all(".show-info")[0]).to have_content("#{@spend.memo}")
      # 編集した月のカテゴリー一覧画面に支出の金額が表示されている
      visit year_month_categories_path(@year, month)
      expect(
        find_all('div[class="category-money-sum"]')[0]
      ).to have_content("#{@spend.money}円")
      # 編集した月のカテゴリー詳細画面に支出の情報が表示されている
      visit year_month_category_path(@year, month, @category.id)
      expect(find_all(".show-info")[0]).to have_content(@category.title)
      expect(find_all(".show-info")[0]).to have_content("#{@spend.money}円")
      expect(find_all(".show-info")[0]).to have_content("#{@spend.memo}")
    end
  end
  context '支出の編集ができない時' do
    it '支出一覧画面で不適な値を入力すると、支出が編集できない' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # 支出を登録する
      regist_spend(@spend, @category)
      # 支出一覧表示画面に遷移する
      visit year_month_path(@year, @month)
      # 登録してある支出の枠をクリックする
      find_all(".show-info")[0].click
      # フォームに不適な内容を入力
      fill_in "Money", with: ""
      find("select[id='category_id']").find("option[value='#{0}']").select_option
      # submitボタンをクリックしてもSpendモデルのカウント数が変動しない
      expect{
        wait_for_ajax(5) do
          find("input[name='commit']").click
        end
      }.to change { Spend.count }.by(0)
      # エラーメッセージが表示されている
      expect(page).to have_content("Categoryを入力してください")
      expect(page).to have_content("Moneyを入力してください")
      expect(page).to have_content("Moneyは数値で入力してください")
      # 支出一覧表示画面の表示内容が変化していない
      expect(find_all(".show-info")[0]).to have_content(Date.today.to_s)
      expect(find_all(".show-info")[0]).to have_content(@category.title)
      expect(find_all(".show-info")[0]).to have_content("#{@spend.money}円")
      expect(find_all(".show-info")[0]).to have_content("#{@spend.memo}")
      # カテゴリー詳細画面の表示内容が変化していない
      visit year_month_category_path(@year, @month, @category.id)
      expect(find_all(".show-info")[0]).to have_content(Date.today.to_s)
      expect(find_all(".show-info")[0]).to have_content(@category.title)
      expect(find_all(".show-info")[0]).to have_content("#{@spend.money}円")
      expect(find_all(".show-info")[0]).to have_content("#{@spend.memo}")
    end
    it 'カテゴリー詳細画面で不適な値を入力すると、支出が編集できない' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # 支出を登録する
      regist_spend(@spend, @category)
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 登録してある支出の枠をクリックする
      find_all(".show-info")[0].click
      # フォームに不適な内容を入力
      fill_in "Money", with: ""
      find("select[id='category_id']").find("option[value='#{0}']").select_option
      expect{
        wait_for_ajax(5) do
          find("input[name='commit']").click
        end
      }.to change { Spend.count }.by(0)
      # エラーメッセージが表示されている
      expect(page).to have_content("Categoryを入力してください")
      expect(page).to have_content("Moneyを入力してください")
      expect(page).to have_content("Moneyは数値で入力してください")
      # 画面の表示内容が変化していない
      expect(find_all(".show-info")[0]).to have_content(Date.today.to_s)
      expect(find_all(".show-info")[0]).to have_content(@category.title)
      expect(find_all(".show-info")[0]).to have_content("#{@spend.money}円")
      expect(find_all(".show-info")[0]).to have_content("#{@spend.memo}")
      # 支出一覧表示画面の表示内容が変化していない
      visit year_month_path(@year, @month)
      expect(find_all(".show-info")[0]).to have_content(Date.today.to_s)
      expect(find_all(".show-info")[0]).to have_content(@category.title)
      expect(find_all(".show-info")[0]).to have_content("#{@spend.money}円")
      expect(find_all(".show-info")[0]).to have_content("#{@spend.memo}")
    end
  end
end

RSpec.describe '支出の削除' do
  before do
    @category = FactoryBot.create(:category)
    @spend = FactoryBot.build(:spend)
    @year = Date.today.year
    @month = Date.today.month
    @day = Date.today.day
    ActionController::Base.allow_forgery_protection = true
  end

  after do
    ActionController::Base.allow_forgery_protection = false
  end

  context '支出の削除ができる時' do
    it '支出一覧表示画面から支出の削除ができる' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # 支出を登録する
      regist_spend(@spend, @category)
      # 支出一覧表示画面に遷移する
      visit year_month_path(@year, @month)
      # 登録してある支出の枠をクリックすると、削除のためのsubmitボタンが出現する
      find_all(".show-info")[0].click
      expect(page).to have_selector("#spend-delete-btn")
      # 削除ボタンをクリックすると、Spendモデルのカウント数が１減少する
      expect{
        wait_for_ajax(5) do
          find("#spend-delete-btn").click
        end
      }.to change { Spend.count }.by(-1)
      # ヘッダーの合計支出額が減少する
      expect(find(".header")).to have_content(0)
      # 削除した支出情報は表示されていない
      expect(page).to have_no_selector("show-info") 
      # カレンダー画面に遷移する
      visit year_month_spends_path(@year, @month)
      # 削除した支出は表示されていない
      expect(find_all(".this-month")[@day-1]).to have_no_content("#{@spend.money}円")
      # カテゴリー一覧表示画面に遷移する
      visit year_month_categories_path(@year, @month)
      # 削除した支出に紐付いたカテゴリーの合計支出額が変化している
      expect(
        find_all('div[class="category-money-sum"]')[0]
      ).to have_content("#{0}円")
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 削除した支出は表示されていない
      expect(page).to have_no_selector("show-info") 
    end
    it 'カテゴリー詳細画面から支出の削除ができる' do
      # Basic認証をパス
      basic_pass(root_path)
      # ログインする
      sign_in(@category.user)
      # 支出を登録する
      regist_spend(@spend, @category)
      # カテゴリー詳細画面に遷移する
      visit year_month_category_path(@year, @month, @category.id)
      # 登録してある支出の枠をクリックすると、削除のためのsubmitボタンが出現する
      find_all(".show-info")[0].click
      expect(page).to have_selector("#spend-delete-btn")
      # 削除ボタンをクリックすると、Spendモデルのカウント数が１減少する
      expect{
        wait_for_ajax(5) do
          find("#spend-delete-btn").click
        end
      }.to change { Spend.count }.by(-1)
      # ヘッダーの合計支出額が減少する
      expect(find(".header")).to have_content(0)
      # 削除した支出情報は表示されていない
      expect(page).to have_no_selector("show-info") 
      # カレンダー画面に遷移する
      visit year_month_spends_path(@year, @month)
      # 削除した支出は表示されていない
      expect(find_all(".this-month")[@day-1]).to have_no_content("#{@spend.money}円")
      # カテゴリー一覧表示画面に遷移する
      visit year_month_categories_path(@year, @month)
      # 削除した支出に紐付いたカテゴリーの合計支出額が変化している
      expect(
        find_all('div[class="category-money-sum"]')[0]
      ).to have_content("#{0}円")
      # 支出一覧表示画面に遷移する
      visit year_month_path(@year, @month)
      # 削除した支出は表示されていない
      expect(page).to have_no_selector("show-info") 
    end
  end
end
