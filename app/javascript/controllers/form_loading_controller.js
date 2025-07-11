import { Controller } from "@hotwired/stimulus"

// This controller hides the form and shows a loading indicator on submission.
export default class extends Controller {
  static targets = ["form", "loading"]

  // This action is triggered when the form is submitted.
  showLoading() {
    // Instantly hide the form.
    this.formTarget.classList.add("hidden")
    // Instantly show the loading indicator.
    this.loadingTarget.classList.remove("hidden")
  }
}
