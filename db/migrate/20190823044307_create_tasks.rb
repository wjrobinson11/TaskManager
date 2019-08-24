class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.integer :company_id

      t.timestamps
    end
  end
end
