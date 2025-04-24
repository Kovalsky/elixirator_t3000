class Task < ApplicationRecord
  belongs_to :project

  # option1: tree structure
  belongs_to :parent, optional: true, class_name: "Task", foreign_key: :parent_id
  has_many :subtasks, class_name: "Task", foreign_key: :parent_id, dependent: :destroy

  # option2: graph structure
  # also possible just to use gem "acts_as_graph"
  has_many :task_dependeny_edges, class_name: "TaskDependencyEdge"
  has_many :ancestors, through: :task_dependeny_edges, source: :ancestor

  has_many :inverse_task_dependeny_edges, class_name: "TaskDependencyEdge", foreign_key: :task_id, dependent: :destroy
  has_many :childrens, through: :inverse_task_dependeny_edges, source: :task

  scope :for_project, ->(project_id) { where(project_id: project_id) }
  scope :non_expired, -> { where("created_at >= ?", 6.month.ago) }
end
