class Spend < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :money, presence: true
  validates :day, presence: true

  private

  def self.display(year, month)
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

    sql = "SELECT * FROM spends WHERE day >= DATE('#{year}-#{month}-01') AND day < DATE('#{next_year}-#{next_month}-01');"
    return Spend.find_by_sql(sql)
  end

  def self.sum(year, month)
    spends = Spend.display(year, month)
    sum = 0
    spends.each do |spend|
      sum += spend.money
    end
    return sum
  end

  def self.each_sums(year, month)
    spends = Spend.display(year, month)
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

  def self.day_sum(spend)
    sql = "SELECT * FROM spends WHERE day = '#{spend.day.to_s}'"
    spends = Spend.find_by_sql(sql)
    sum = 0
    spends.each do |s|
      sum += s.money
    end
    return sum
  end
end
