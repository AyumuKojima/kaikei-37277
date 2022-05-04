class CategoriesController < ApplicationController
  before_action :set_year_and_month
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
    @each_day_spends = Spend.get_each_day_spends(current_user.id, @year, @month, params[:id].to_i)
    @select_categories = Category.add_for_selector(current_user.id)
    @index = @select_categories.index(@category)
  end

  def update
    category = Category.find(params[:id])
    if category.update(category_params)
      render json: { error: false }
    else
      render json: { error_messages: category.errors.full_messages, error: true }
    end
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy
    redirect_to year_month_categories_path(@year, @month)
  end

  private

  def category_params
    params.permit(:title, :color_id).merge(user_id: current_user.id)
  end

  def set_year_and_month
    @year = params[:year_id].to_i
    @month = params[:month_id].to_i
    if @year > Date.today.year + 10 || @year < Date.today.year - 50 || @month > 12 || @month < 1
      redirect_to year_month_spends_path(Date.today.year, Date.today.month)
    end
  end

  def set_category
    @categories = Category.where(user_id: current_user.id)
    @colors = Color.all
    @sum = Spend.sum(current_user.id, @year, @month)
    @each_sums = Spend.get_each_category_sums(current_user.id, @year, @month)
    @each_props = Spend.get_each_category_props(current_user.id, @year, @month)
  end
end
