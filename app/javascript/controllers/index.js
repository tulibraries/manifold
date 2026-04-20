import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { application } from "controllers/application"

eagerLoadControllersFrom("controllers/common", application)
eagerLoadControllersFrom("controllers/application", application)
