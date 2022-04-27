class RenameCategoryNameColumnToCategories < ActiveRecord::Migration[6.0]
  def change
    rename_column :categories, :category_name, :title
  end
end
