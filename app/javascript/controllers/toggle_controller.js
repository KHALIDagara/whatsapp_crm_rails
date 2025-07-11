import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("stimulus is working " )
    this.interval = setInterval(() => {
      console.log("Hello World")
    }, 2000)
  }

  disconnect() {
    clearInterval(this.interval)
  }
}

