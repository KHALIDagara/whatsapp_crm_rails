import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bulk-selection"
export default class extends Controller {

  static targets = ["selectAll", "checkbox"]
  connect() {
	console.log("bulk stimulus is connected ! ");
}

  // This function is triggered when the "select all" checkbox is clicked.
  toggleAll() {
    // Set the checked status of all individual checkboxes
    // to match the status of the "select all" checkbox.
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = this.selectAllTarget.checked
    })
  }

}



