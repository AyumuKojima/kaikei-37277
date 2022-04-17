class MonthsController < ApplicationController
  def index
    redirect_to year_month_spends_path(Date.today.year, Date.today.month)
  end

  def show
    @month = params[:id].to_i
    @year = params[:year_id].to_i
    @sum = Spend.sum(@year, @month)
    @each_day_spends = Spend.get_each_day_spends(@year, @month)
  end
end
