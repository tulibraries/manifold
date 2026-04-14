import { application } from "controllers/application"
import DigcolsCarouselController from "controllers/digcols_carousel_controller"
import EtextsComponentController from "controllers/etexts_component_controller"
import ExternalLinksController from "controllers/external_links_controller"
import FailoverDesktopController from "controllers/failover_desktop_controller"
import FailoverGlobalController from "controllers/failover_global_controller"
import FailoverGlobalMobileController from "controllers/failover_global_mobile_controller"
import FailoverMobileController from "controllers/failover_mobile_controller"
import FormSubmissionsController from "controllers/form_submissions_controller"
import HighlightsCarouselController from "controllers/highlights_carousel_controller"
import JumbleController from "controllers/jumble_controller"
import NewsCarouselController from "controllers/news_carousel_controller"
import PeopleController from "controllers/people_controller"
import PrintController from "controllers/print_controller"
import SearchFormController from "controllers/search_form_controller"
import SelectizeController from "controllers/selectize_controller"
import WpviController from "controllers/wpvi_controller"

application.register("digcols-carousel", DigcolsCarouselController)
application.register("etexts-component", EtextsComponentController)
application.register("external-links", ExternalLinksController)
application.register("failover-desktop", FailoverDesktopController)
application.register("failover-global", FailoverGlobalController)
application.register("failover-global-mobile", FailoverGlobalMobileController)
application.register("failover-mobile", FailoverMobileController)
application.register("form-submissions", FormSubmissionsController)
application.register("highlights-carousel", HighlightsCarouselController)
application.register("jumble", JumbleController)
application.register("news-carousel", NewsCarouselController)
application.register("people", PeopleController)
application.register("print", PrintController)
application.register("search-form", SearchFormController)
application.register("selectize", SelectizeController)
application.register("wpvi", WpviController)
