class SpendsController < ApplicationController

  def index
    fake_category = Category.new(id: 0, title: "カテゴリーを選択してください")
    @select_categories = [fake_category].push(Category.all).flatten!
    @spend = Spend.new
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
