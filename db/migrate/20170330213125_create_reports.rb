class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :created_by, null: false
      t.datetime :created_at, null: false

      t.timestamps null: false
    end
  end
end
