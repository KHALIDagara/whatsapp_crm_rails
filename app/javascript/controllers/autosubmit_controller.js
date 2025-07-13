import { Controller } from "@hotwired/stimulus"
import { useDebounce } from "stimulus-use"

// Connects to data-controller="autosubmit"
export default class extends Controller {
  static debounces = ['submit']
  connect() {
	  console.log(" the autosubmit controller is connected successfully " );
	  useDebounce(this, { wait:300 } )
  }
  submit() { 
	  this.element.requestSubmit() 
  }
}
