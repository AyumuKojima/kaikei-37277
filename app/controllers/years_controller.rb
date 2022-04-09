class YearsController < ApplicationController
  def index
    redirect_to year_month_spends_path(Date.today.year, Date.today.month)
  end
end
