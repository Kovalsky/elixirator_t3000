class ProjectsController < ApplicationController
  def index
    @pagy, @projects = pagy_countless(Project.with_non_expired_tasks)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def tasks
    @tasks = Task.for_project(params[:id]).non_expired

    render partial: "projects/tasks_list", locals: { tasks: @tasks, project_id: params[:id] }
  end
end
