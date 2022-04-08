class Category < ApplicationRecord
  belongs_to :user
  has_many :spends

  validates :title, presence: true
end
