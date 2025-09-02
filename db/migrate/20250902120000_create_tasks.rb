class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.boolean :completed, null: false, default: false
      t.date :due_date
      t.integer :priority
      t.integer :position
      t.timestamps
    end

    add_index :tasks, :completed
    add_index :tasks, :due_date
    add_index :tasks, :priority
    add_index :tasks, :position
    add_index :tasks, [:completed, :due_date]
  end
end

