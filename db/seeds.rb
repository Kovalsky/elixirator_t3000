# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
PROJECTS_COUNT = 100
TASKS_COUNT = 25..100
Project.delete_all
Task.delete_all

# Create projects
projects = Array.new(PROJECTS_COUNT) { { name: Faker::Company.name } }
project_ids = Project.insert_all(projects, returning: [:id]).map { |record| record["id"] }
puts "Created #{project_ids.size} projects"

# Create tasks
all_tasks = []

project_ids.each do |project_id|
  tasks =
    Array.new(rand(TASKS_COUNT)) do
      {
        title: Faker::Lorem.sentence(word_count: 3),
        description: Faker::Lorem.paragraph(sentence_count: 2),
        project_id: project_id,
        created_at: Time.current - 6.months + [-10, 10, 20, 30].sample.days
      }
    end
  all_tasks << Task.insert_all(tasks, returning: [:id, :project_id])
  puts "Created #{tasks.size} tasks for project ID #{project_id}"
end
all_tasks.flatten!

# Create task dependency edges
edges = []

grouped_by_project = all_tasks.group_by { |task| task["project_id"] }

grouped_by_project.each do |_project_id, tasks|
  sorted_tasks = tasks.sort_by { |t| t["id"] }

  sorted_tasks.each_with_index do |task, i|
    task_id = task["id"]
    possible_ancestors = sorted_tasks[0...i].reject { |t| t["id"] == task_id }.sample(rand(0..2))

    possible_ancestors.each do |ancestor|
      next if ancestor["id"] == task_id
      edges << {
        task_id: task_id,
        ancestor_id: ancestor["id"],
        created_at: Time.current,
        updated_at: Time.current
      }
    end
  end
end

unique_edges = edges.uniq { |edge| [edge[:task_id], edge[:ancestor_id]] }
TaskDependencyEdge.insert_all(unique_edges)
puts "Created #{unique_edges.size} task dependency edges"
