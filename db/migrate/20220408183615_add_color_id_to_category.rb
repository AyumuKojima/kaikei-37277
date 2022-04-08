class AddColorIdToCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :color_id, :integer
  end
end
