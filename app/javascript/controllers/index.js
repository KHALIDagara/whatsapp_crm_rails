import { application } from "controllers/application"

// Import and register all controllers with proper paths
import HelloController from "controllers/hello_controller"
import FormLoadingController from "controllers/form_loading_controller"
import ToggleController from "controllers/toggle_controller"
import TestController from "controllers/test_controller"
import QrStatusController from "controllers/qr_status_controller"

application.register("hello", HelloController)
application.register("form-loading", FormLoadingController)
application.register("toggle", ToggleController)
application.register("test", TestController)
application.register("qr-status", QrStatusController)
