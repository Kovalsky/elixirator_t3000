class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.references :project, null: false, foreign_key: true
      t.integer :parent_id

      t.timestamps
    end

    add_index :tasks, :created_at
    add_index :tasks, :parent_id
  end
end
