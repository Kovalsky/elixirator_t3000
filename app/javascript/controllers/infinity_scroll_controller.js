import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loadMore"]

  connect() {
    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.loadNextPage();
        }
      });
    });

    observer.observe(this.loadMoreTarget);
  }

  loadNextPage() {
    if (this.hasLoadMoreTarget) {
      this.loadMoreTarget.click()
      console.log(this.loadMoreTarget)
    } 
  }
}
