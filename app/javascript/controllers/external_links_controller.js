import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const links = document.querySelectorAll("a[href]");

    links.forEach((link) => {
      const isExternalHost = link.hostname && link.hostname !== location.hostname;
      const isLibrarySearch = link.href.includes("librarysearch.temple.edu");

      if (isExternalHost || isLibrarySearch) {
        link.target = "_blank";
        link.rel = "noopener noreferrer";
      }
    });
  }
}
