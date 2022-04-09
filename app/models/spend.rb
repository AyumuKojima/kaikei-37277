class Spend < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :money, presence: true
  validates :day, presence: true

  private

  def self.display(year, month)
    if month < 10
      sql = "SELECT * FROM spends WHERE day >= DATE('#{year}-0#{month}-01');"
    else
      sql = "SELECT * FROM spends WHERE day >= DATE('#{year}-#{month}-01');"
    end
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
end
