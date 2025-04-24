class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy

  scope :with_non_expired_tasks, -> { includes(:tasks).where("tasks.created_at >= ?", 6.months.ago).references(:tasks) }
end
