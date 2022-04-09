class CategoriesController < ApplicationController

  def index
    @categories = Category.all
    @category = Category.new
    @colors = Color.all
    @sum = 0
    @categories.each do |category|
      category.spends.each do |spend|
        @sum += spend.money
      end
    end
    @each_sums = []
    @categories.each do |category|
      each_sum = 0
      category.spends.each do |spend|
        each_sum += spend.money
      end
      @each_sums << each_sum
    end
    @each_props = []
    @each_sums.each do |each_sum|
      @each_props << (each_sum * 100 / @sum).floor
    end
  end

  def create
    
  end

  private

  def category_params
    
  end
end
