class Spend < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :money, presence: true
  validates :day, presence: true
end
