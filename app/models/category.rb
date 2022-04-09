class Category < ApplicationRecord
  belongs_to :user
  has_many :spends

  validates :title, presence: true

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :color

  validates :color_id, numericality: {other_than: 0, message: "Color can't be blank"}
end
