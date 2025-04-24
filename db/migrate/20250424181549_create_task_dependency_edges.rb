class CreateTaskDependencyEdges < ActiveRecord::Migration[8.0]
  def change
    create_table :task_dependency_edges do |t|
      t.references :task, null: false, foreign_key: true
      t.references :ancestor, null: false, foreign_key: { to_table: :tasks }

      t.timestamps
    end

    add_index :task_dependency_edges, [:task_id, :ancestor_id], unique: true
  end
end
