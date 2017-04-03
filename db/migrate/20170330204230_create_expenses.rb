class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :owner_id, null: false
      t.datetime :datetime, null: false
      t.integer :weeknum, null: false
      t.float :amount, null: false
      t.string :description, null: false

      t.timestamps null: false
    end
    add_index :expenses, :owner_id
    add_index :expenses, :weeknum
  end
end
