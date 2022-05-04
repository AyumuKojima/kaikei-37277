class Spend < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :money, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 99999999 }
  validates :day, presence: true
  validates :memo, length: {maximum: 200}

  private

  def self.display(user_id, year, month, category_id=nil)
    if month == 12
      next_year = year + 1
      next_month = 1
    else
      next_year = year
      next_month = month + 1
    end

    if month < 10
      month = "0#{month}"
    end

    if next_month < 10
      next_month = "0#{next_month}"
    end 
    if category_id == nil
      sql = "SELECT * FROM spends WHERE day >= DATE('#{year}-#{month}-01') AND day < DATE('#{next_year}-#{next_month}-01') AND user_id = #{user_id};"
    else
      sql = "SELECT * FROM spends WHERE day >= DATE('#{year}-#{month}-01') AND day < DATE('#{next_year}-#{next_month}-01') AND user_id = #{user_id} AND category_id = #{category_id};"
    end
    return Spend.find_by_sql(sql)
  end

  def self.get_each_day_spends(user_id, year, month, category_id=nil)
    if month < 10
      month_ = "0#{month}"
    else
      month_ = month
    end
    each_day_spends = []
    Date.new(year, month, 1).end_of_month.day.times do |i|
      spends = []
      if i+1 < 10
        day = "0#{i+1}"
      else
        day = i+1
      end
      if category_id == nil
        sql = "SELECT * FROM spends WHERE day = DATE('#{year}-#{month_}-#{day}') AND user_id = #{user_id};"
      else
        sql = "SELECT * FROM spends WHERE day = DATE('#{year}-#{month_}-#{day}') AND user_id = #{user_id} AND category_id = #{category_id};"
      end
      spends = Spend.find_by_sql(sql)
      each_day_spends << spends
    end
    return each_day_spends
  end

  def self.sum(user_id, year, month, category_id=nil)
    spends = Spend.display(user_id, year, month, category_id)
    sum = 0
    spends.each do |spend|
      sum += spend.money
    end
    return sum
  end

  def self.each_day_sums(user_id, year, month)
    spends = Spend.display(user_id, year, month)
    each_sums = []
    Date.new(year, month, 1).end_of_month.day.times do |i|
      each_sum = 0
      spends.each do |spend|
        if spend.day.day == i+1
          each_sum += spend.money
        end
      end
      each_sums << each_sum
    end
    return each_sums
  end

  def self.day_sum(user_id, spend)
    sql = "SELECT * FROM spends WHERE day = '#{spend.day.to_s}' AND user_id = #{user_id}"
    spends = Spend.find_by_sql(sql)
    sum = 0
    spends.each do |s|
      sum += s.money
    end
    return sum
  end

  def self.get_each_category_sums(user_id, year, month)
    each_category_sums = []
    User.find(user_id).categories.each do |category|
      category_sum = 0
      Spend.display(user_id, year, month, category.id).each do |spend|
        category_sum += spend.money
      end
      each_category_sums << category_sum
    end
    return each_category_sums
  end

  def self.get_each_category_props(user_id, year, month)
    each_category_sums = Spend.get_each_category_sums(user_id, year, month)
    sum = Spend.sum(user_id, year, month)
    each_category_props = []
    if sum != 0
      each_category_sums.each do |category_sum|
        each_category_props << (category_sum * 100 / sum).floor
      end
    else
      each_category_sums.each do
        each_category_props << 0
      end
    end
    return each_category_props
  end
end
