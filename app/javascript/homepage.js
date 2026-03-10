import { application } from "./bootstrap"
import JumbleController from "./controllers/jumble_controller"
import ExternalLinksController from "./controllers/external_links_controller"
import NewsCarouselController from "./controllers/news_carousel_controller"
import HighlightsCarouselController from "./controllers/highlights_carousel_controller"
import DigcolsCarouselController from "./controllers/digcols_carousel_controller"
import FailoverDesktopController from "./controllers/failover_desktop_controller"
import FailoverMobileController from "./controllers/failover_mobile_controller"
import FailoverGlobalController from "./controllers/failover_global_controller"
import FailoverGlobalMobileController from "./controllers/failover_global_mobile_controller"

application.register("jumble", JumbleController)
application.register("external-links", ExternalLinksController)
application.register("news-carousel", NewsCarouselController)
application.register("highlights-carousel", HighlightsCarouselController)
application.register("digcols-carousel", DigcolsCarouselController)
application.register("failover-desktop", FailoverDesktopController)
application.register("failover-mobile", FailoverMobileController)
application.register("failover-global", FailoverGlobalController)
application.register("failover-global-mobile", FailoverGlobalMobileController)
