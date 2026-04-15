import { application } from "controllers/application"
import DigcolsCarouselController from "controllers/digcols_carousel_controller"
import HighlightsCarouselController from "controllers/highlights_carousel_controller"
import NewsCarouselController from "controllers/news_carousel_controller"

application.register("digcols-carousel", DigcolsCarouselController)
application.register("highlights-carousel", HighlightsCarouselController)
application.register("news-carousel", NewsCarouselController)
