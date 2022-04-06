class CreateSpends < ActiveRecord::Migration[6.0]
  def change
    create_table :spends do |t|
      t.string :title, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
      t.integer :money, null: false
      t.date :day, null: false
      t.string :memo
    end
  end
end
