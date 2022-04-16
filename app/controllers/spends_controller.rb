class SpendsController < ApplicationController
  before_action :set_spend, only: [:index, :create]

  def index
    #binding.pry
    @spend = Spend.new
  end

  def create
    spend = Spend.create(spend_params)
    sum = Spend.day_sum(spend)
    render json: { spend: spend, sum: sum }
  end

  private

  def spend_params
    params.permit(:money, :memo, :category_id, :day).merge(user_id: current_user.id)
  end

  def set_spend
    @year = params[:year_id].to_i
    @month = params[:month_id].to_i
    @select_categories = Category.add_for_index
    @spends = Spend.display(@year, @month)
    @sum = Spend.sum(@year, @month)
    @each_sums = Spend.each_sums(@year, @month)
  end
end
