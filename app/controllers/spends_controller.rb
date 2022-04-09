class SpendsController < ApplicationController

  def index
    @display_month = [Date.today.year, Date.today.month]
    fake_category = Category.new(id: 0, title: "カテゴリーを選択してください")
    @select_categories = [fake_category].push(Category.all).flatten!
    @spend = Spend.new
    @spends = Spend.all
    @sum = 0
    @spends.each do |spend|
      @sum += spend.money
    end
    @each_sums = []
    Date.today.end_of_month.day.times do |i|
      each_sum = 0
      @spends.each do |spend|
        if spend.day.day == i+1
          each_sum += spend.money
        end
      end
      @each_sums << each_sum
    end
  end

  def create
    fake_category = Category.new(id: 0, title: "カテゴリーを選択してください")
    @select_categories = [fake_category].push(Category.all).flatten!
    @spend = Spend.new(spend_params)
    if @spend.save
      redirect_to root_path
    else
      render :index
    end
  end

  private

  def spend_params
    params.require(:spend).permit(:money, :memo, :category_id, :day).merge(user_id: current_user.id)
  end
end
