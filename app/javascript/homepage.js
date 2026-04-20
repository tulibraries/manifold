import "@hotwired/turbo-rails"
import "legacy-libs"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { application } from "controllers/application"
import "controllers"

eagerLoadControllersFrom("controllers/homepage", application)
