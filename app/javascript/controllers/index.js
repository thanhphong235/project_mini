// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import SearchController from "./search_controller"
application.register("search", SearchController)

eagerLoadControllersFrom("controllers", application)
