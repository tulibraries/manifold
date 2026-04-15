import "@hotwired/turbo-rails"
import "legacy-libs"
import { application } from "controllers/application"
import DigcolsCarouselController from "controllers/digcols_carousel_controller"
import ExternalLinksController from "controllers/external_links_controller"
import FailoverDesktopController from "controllers/failover_desktop_controller"
import FailoverGlobalMobileController from "controllers/failover_global_mobile_controller"
import FailoverMobileController from "controllers/failover_mobile_controller"
import HighlightsCarouselController from "controllers/highlights_carousel_controller"
import JumbleController from "controllers/jumble_controller"
import NewsCarouselController from "controllers/news_carousel_controller"

application.register("external-links", ExternalLinksController)
application.register("failover-desktop", FailoverDesktopController)
application.register("failover-global-mobile", FailoverGlobalMobileController)
application.register("failover-mobile", FailoverMobileController)
application.register("digcols-carousel", DigcolsCarouselController)
application.register("highlights-carousel", HighlightsCarouselController)
application.register("jumble", JumbleController)
application.register("news-carousel", NewsCarouselController)
