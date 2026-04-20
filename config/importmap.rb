# frozen_string_literal: true

pin "application", preload: "application"
pin "homepage", preload: "homepage"
pin "jquery", to: "jquery.js", preload: false
pin "bootstrap", to: "bootstrap.js", preload: false
pin "selectize", to: "selectize.js", preload: false

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: false
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: false
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: false
pin "@rails/actiontext", to: "actiontext.esm.js", preload: "application"
pin "trix", to: "vendor/trix.js", preload: "application"
pin "hotkeys-js", to: "vendor/hotkeys-js.js", preload: false
pin "stimulus-use", to: "vendor/stimulus-use.js", preload: false

pin "controllers", to: "controllers/index.js", preload: "application"
pin "administrate-trix", to: "src/administrate-trix.js", preload: "application"
pin "legacy-libs", to: "src/legacy-libs.js", preload: "application"
pin "src/jquery", to: "src/jquery.js", preload: false
pin "src/common-libs", to: "src/common-libs.js", preload: false
pin_all_from "app/javascript/controllers", under: "controllers", preload: false
