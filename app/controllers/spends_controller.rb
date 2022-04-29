class SpendsController < ApplicationController
  before_action :set_spend, only: [:index, :create, :update, :destroy]

  def index
    @select_categories = Category.add_for_index
    @spends = Spend.display(@year, @month)
    @sum = Spend.sum(@year, @month)
    @each_sums = Spend.each_sums(@year, @month)
    if @month == 1
      @last_month_sums = Spend.each_sums(@year - 1, 12)
    else
      @last_month_sums = Spend.each_sums(@year, @month - 1)
    end

    if @month == 12
      @next_month_sums = Spend.each_sums(@year + 1, 1)
    else
      @next_month_sums = Spend.each_sums(@year, @month + 1)
    end
    @spend = Spend.new
  end

  def create
    @spend = Spend.new(spend_params)
    if @spend.save
      day_sum = Spend.day_sum(@spend)
      sum = Spend.sum(@year, @month)
      render json: { spend: @spend, day_sum: day_sum, sum: sum, error: false }
    elsif
      render json: { error_messages: @spend.errors.full_messages, error: true }
    end
  end

  def update
    spend = Spend.find(params[:id])
    old_spend_day = spend.day.day
    spend.update(spend_params)
    sum = Spend.sum(@year, @month)
    index = params[:index].to_i
    past_category_id = params[:past_category_id].to_i
    category_sum = Spend.get_each_category_sums(@year, @month)[past_category_id-1]
    prop = Spend.get_each_category_props(@year, @month)[past_category_id-1]
    render json: { spend: spend, sum: sum, old_spend_day: old_spend_day, index: index, past_category_id: past_category_id, category_sum: category_sum, prop: prop }
  end

  def destroy
    spend = Spend.find(params[:id])
    spend.destroy
    sum = Spend.sum(@year, @month)
    index = params[:index].to_i
    category_id = params[:id].to_i
    category_sum = Spend.get_each_category_sums(@year, @month)[category_id-1]
    prop = Spend.get_each_category_props(@year, @month)[category_id-1]
    render json: { index: index, sum: sum, category_sum: category_sum, prop: prop }
  end

  private

  def spend_params
    params.permit(:money, :memo, :category_id, :day).merge(user_id: current_user.id)
  end

  def set_spend
    @year = params[:year_id].to_i
    @month = params[:month_id].to_i
    if @year > Date.today.year + 10 || @year < Date.today.year - 50 || @month > 12 || @month < 1
      redirect_to year_month_spends_path(Date.today.year, Date.today.month)
    end
  end
end
