class Category < ApplicationRecord
  belongs_to :user
  has_many :spends

  validates :title, presence: true, length: { maximum: 10 }

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :color

  validates :color_id, numericality: {other_than: 0, message: "Color can't be blank"}

  private

  def self.add_for_index
    fake_category = Category.new(id: 0, title: "カテゴリーを選択してください")
    return [fake_category].push(Category.all).flatten!
  end
end
