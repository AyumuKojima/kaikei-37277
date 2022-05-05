class Category < ApplicationRecord
  belongs_to :user
  has_many :spends, dependent: :destroy

  validates :title, presence: true, length: { maximum: 10 }

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :color

  validates :color_id, numericality: {other_than: 0, message: "を選択してください"}

  private

  def self.add_for_selector(user_id)
    fake_category = Category.new(id: 0, title: "カテゴリーを選択")
    return [fake_category].push(Category.where(user_id: user_id)).flatten!
  end
end
