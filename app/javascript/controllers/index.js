import { application } from "./application"

// Import your custom controllers here
import BulkSelectionController from "./bulk_selection_controller.js"
import AutosubmitController from "./autosubmit_controller.js"

// Register your controllers with Stimulus
application.register("bulk-selection", BulkSelectionController)
application.register("autosubmit", AutosubmitController)
