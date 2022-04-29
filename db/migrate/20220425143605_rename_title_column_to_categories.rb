class RenameTitleColumnToCategories < ActiveRecord::Migration[6.0]
  def change
    rename_column :categories, :title, :category_name
  end
end
