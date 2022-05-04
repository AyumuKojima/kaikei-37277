class MonthsController < ApplicationController
  def index
    redirect_to year_month_spends_path(Date.today.year, Date.today.month)
  end

  def show
    @month = params[:id].to_i
    @year = params[:year_id].to_i
    @sum = Spend.sum(current_user.id, @year, @month)
    @categories = Category.where(user_id: current_user.id)
    @each_day_spends = Spend.get_each_day_spends(current_user.id, @year, @month)
    @select_categories = Category.add_for_selector(current_user.id)
    @colors = Color.all
  end
end
