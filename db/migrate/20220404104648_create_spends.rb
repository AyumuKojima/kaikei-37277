class CreateSpends < ActiveRecord::Migration[6.0]
  def change
    create_table :spends do |t|
      t.integer    :money,      null: false
      t.date       :day,        null: false
      t.string     :memo
      t.timestamps
    end
  end
end
