class CategoriesController < ApplicationController
  before_action :set_category, only: [:index, :create, :show, :update]

  def index
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to year_month_categories_path(@year, @month)
    else
      render :index
    end
  end

  def show
    @category = Category.find(params[:id])
    @each_day_spends = Spend.get_each_day_spends(@year, @month)
    @select_categories = Category.add_for_index
  end

  def update
    @category = Category.find(params[:id])
    @category.update(category_params)
    @categories = Category.all
    redirect_to year_month_category_path(@year, @month, @category.id)
  end

  def destroy
  end

  private

  def category_params
    params.permit(:title, :color_id).merge(user_id: current_user.id)
  end

  def set_category
    @year = params[:year_id].to_i
    @month = params[:month_id].to_i
    if @year > Date.today.year + 10 || @year < Date.today.year - 50 || @month > 12 || @month < 1
      redirect_to year_month_spends_path(Date.today.year, Date.today.month)
    end
    @categories = Category.all
    @colors = Color.all
    @sum = Spend.sum(@year, @month)
    @each_sums = Spend.get_each_category_sums(@year, @month)
    @each_props = Spend.get_each_category_props(@year, @month)
  end
end
