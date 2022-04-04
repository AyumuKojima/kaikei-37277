class CreateSpends < ActiveRecord::Migration[6.0]
  def change
    create_table :spends do |t|

      t.timestamps
    end
  end
end
