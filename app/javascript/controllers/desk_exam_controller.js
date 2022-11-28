import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  formtype(event) {
    let type = event["target"]["value"]
    type == "Desk Copy" ? this.desk() : this.exam()
  }
  exam() {
    document.getElementById("examcopy").style.display = "block";
    document.getElementById("deskcopy").style.display = "none";
    document.getElementById("bookstore").style.display = "none";
    document.getElementById("form_authorized_bookstore").classList.remove("required");
    document.getElementById("form_authorized_bookstore").removeAttribute("required", "required");
    document.getElementById("form_format_ebook").classList.remove("required");
    document.getElementById("form_format_ebook").removeAttribute("required", "required");
    document.getElementById("form_format_ebook").setAttribute("aria-required", "false");
    document.getElementById("form_format_print").classList.remove("required");
    document.getElementById("form_format_print").removeAttribute("required", "required");
    document.getElementById("form_format_print").setAttribute("aria-required", "false");
  }
  desk() {
    document.getElementById("examcopy").style.display = "none";
    document.getElementById("deskcopy").style.display = "block";
    document.getElementById("bookstore").style.display = "block";
    document.getElementById("form_authorized_bookstore").classList.add("required");
    document.getElementById("form_authorized_bookstore").setAttribute("required", "required");
    document.getElementById("form_format_ebook").classList.add("required");
    document.getElementById("form_format_ebook").setAttribute("required", "required");
    document.getElementById("form_format_ebook").setAttribute("aria-required", "true");
    document.getElementById("form_format_print").classList.add("required");
    document.getElementById("form_format_print").setAttribute("required", "required");
    document.getElementById("form_format_print").setAttribute("aria-required", "true");
  }
}