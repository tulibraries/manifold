import "@hotwired/turbo-rails"
import "src/common-libs"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { application } from "controllers/application"

eagerLoadControllersFrom("controllers/common", application)
eagerLoadControllersFrom("controllers/homepage", application)
