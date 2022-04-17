class MonthsController < ApplicationController
  def index
    redirect_to year_month_spends_path(Date.today.year, Date.today.month)
  end

  def show
    @month = params[:id].to_i
    @year = params[:year_id].to_i
  end
end
