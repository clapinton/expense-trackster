class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :owner_id, null: false
      t.datetime :datetime, null: false
      t.string :amount, null: false
      t.string :description, null: false

      t.timestamps null: false
    end
    add_index :expenses, :owner_id
  end
end
