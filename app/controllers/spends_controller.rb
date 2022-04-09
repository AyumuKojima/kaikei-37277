class SpendsController < ApplicationController
  before_action :set_spend, only: [:index, :create]

  def index
    @spend = Spend.new
  end

  def create
    @spend = Spend.new(spend_params)
    if @spend.save
      redirect_to year_month_spends_path(year, month)
    else
      render :index
    end
  end

  private

  def spend_params
    params.require(:spend).permit(:money, :memo, :category_id, :day).merge(user_id: current_user.id)
  end

  def set_spend
    year = params[:year_id].to_i
    month = params[:month_id].to_i
    @select_categories = Category.add_for_index
    @spends = Spend.display(year, month)
    @sum = Spend.sum(year, month)
    @each_sums = Spend.each_sums(year, month)
  end
end
