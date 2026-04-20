# frozen_string_literal: true

pin "application"
pin "homepage"
pin "jquery", to: "jquery.js"
pin "bootstrap", to: "bootstrap.js"
pin "selectize", to: "selectize.js"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "trix", to: "vendor/trix.js"
pin "hotkeys-js", to: "vendor/hotkeys-js.js"
pin "stimulus-use", to: "vendor/stimulus-use.js"

pin "controllers", to: "controllers/index.js"
pin "administrate-trix", to: "src/administrate-trix.js"
pin "legacy-libs", to: "src/legacy-libs.js"
pin "src/jquery", to: "src/jquery.js"
pin_all_from "app/javascript/controllers", under: "controllers"
