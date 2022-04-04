class CreateSpends < ActiveRecord::Migration[6.0]
  def change
    create_table :spends do |t|

      t.timestamps
      t.integer :money, null: false
      t.date :day, null: false
      t.string :memo
    end
  end
end
