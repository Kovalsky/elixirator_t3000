// app/javascript/controllers/projects_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row"]
  static values = { projectId: Number }

  connect() {
    this.observeNewProjects()
  }

  toggleTasks(event) {
    const row = event.currentTarget
    const projectId = parseInt(row.dataset.projectsProjectIdValue, 10)
    const frame = document.getElementById(`project-${projectId}-tasks`)
    if (!frame) return

    const isLoaded = frame.innerHTML.trim().length > 0
    this.closeAllExcept(projectId)

    if (isLoaded) {
      frame.classList.toggle("hidden")
    } else {
      frame.src = `/projects/${projectId}/tasks`
      frame.classList.remove("hidden")
    }
  }

  closeAllExcept(openId) {
    this.rowTargets.forEach(row => {
      const projectId = parseInt(row.dataset.projectsProjectIdValue, 10)
      const frame = document.getElementById(`project-${projectId}-tasks`)
      if (frame && projectId !== openId) {
        frame.classList.add("hidden")
      }
    })
  }

  observeNewProjects() {
    const observer = new MutationObserver(mutations => {
      mutations.forEach(mutation => {
        mutation.addedNodes.forEach(node => {
          if (node.nodeType === 1 && node.matches('[data-projects-project-id-value]')) {
            node.addEventListener("click", this.toggleTasks.bind(this))
          }
        })
      })
    })

    observer.observe(this.element, { childList: true, subtree: true })
  }
}  
