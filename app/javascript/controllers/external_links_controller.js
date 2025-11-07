import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	connect() {
    const forcedBlankPaths = ["/services/instruction-class-visits"];
		const forcedDomains = ["librarysearch.temple.edu"];
		const anchors = document.querySelectorAll("a");

		anchors.forEach((anchor) => {
			const href = anchor.getAttribute("href");
			if (!href) return;

			let url;
			try {
				url = new URL(href, window.location.origin);
			} catch {
				return; // skip malformed URLs
			}

			const matchesForcedPath = forcedBlankPaths.some(
				(path) => url.pathname === path || url.pathname.startsWith(`${path}/`)
			);
			const matchesForcedDomain = forcedDomains.some((domain) =>
				url.hostname === domain || url.hostname.endsWith(`.${domain}`)
			);
			const isExternal = url.hostname !== window.location.hostname;

			if (matchesForcedPath || matchesForcedDomain || isExternal) {
				anchor.target = "_blank";
				anchor.rel = anchor.rel ? `${anchor.rel} noopener noreferrer`.trim() : "noopener noreferrer";
			}
		});
	}
}
