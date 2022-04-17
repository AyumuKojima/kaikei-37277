class CategoriesController < ApplicationController
  before_action :set_category, only: [:index, :create]

  def index
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    
    if @category.save
      redirect_to categories_path
    else
      render :index
    end
  end

  private

  def category_params
    params.require(:category).permit(:title, :color_id).merge(user_id: current_user.id)
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
