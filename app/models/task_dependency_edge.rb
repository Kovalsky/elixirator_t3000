class TaskDependencyEdge < ApplicationRecord
  belongs_to :task
  belongs_to :ancestor, class_name: "Task"

  validate :cannot_depend_on_self

  def cannot_depend_on_self
    if task_id == ancestor_id
      errors.add(:ancestor_id, "cannot be the same as task_id")
    end
  end
end
