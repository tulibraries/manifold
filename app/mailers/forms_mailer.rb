# frozen_string_literal: true

class FormsMailer < ApplicationMailer
  default from: "templelibraries@gmail.com"

  def ask_scrc(name, email, tuid, phone, affiliation, department, pickup_location, cancel_by, title, author, callnum, comments, subsitute_edition)
    @body = ""
    @body << "Name: " + name.to_s + "<br>"
    @body << "Email: " + email.to_s + "<br>"
    @body << "TUid: " + tuid.to_s + "<br>"
    @body << "Phone: " + phone.to_s + "<br>"
    @body << "Affiliation: " + affiliation.to_s + "<br>"
    @body << "Department: " + department.to_s + "<br>"
    @body << "Pickup Location: " + pickup_location.to_s + "<br>"
    @body << "Cancel by: " + cancel_by.to_s + "<br>"
    @body << "Title: " + title.to_s + "<br>"
    @body << "Author: " + author.to_s + "<br>"
    @body << "Call Number: " + callnum.to_s + "<br>"
    @body << "Comments: " + comments.to_s + "<br>"
    @body << "Substitute Edition?: " + subsitute_edition.to_s + "<br>"
    mail(to: "cdoyle@temple.edu", subject: "Recall Request") do |format|
      format.html { render layout: "recall" }
      format.text { render layout: "recall" }
    end
  end
  def contact(name, email, tuid, phone, affiliation, department, pickup_location, cancel_by, title, author, callnum, comments, subsitute_edition)
    @body = ""
    @body << "Name: " + name.to_s + "<br>"
    @body << "Email: " + email.to_s + "<br>"
    @body << "TUid: " + tuid.to_s + "<br>"
    @body << "Phone: " + phone.to_s + "<br>"
    @body << "Affiliation: " + affiliation.to_s + "<br>"
    @body << "Department: " + department.to_s + "<br>"
    @body << "Pickup Location: " + pickup_location.to_s + "<br>"
    @body << "Cancel by: " + cancel_by.to_s + "<br>"
    @body << "Title: " + title.to_s + "<br>"
    @body << "Author: " + author.to_s + "<br>"
    @body << "Call Number: " + callnum.to_s + "<br>"
    @body << "Comments: " + comments.to_s + "<br>"
    @body << "Substitute Edition?: " + subsitute_edition.to_s + "<br>"
    mail(to: "cdoyle@temple.edu", subject: "Recall Request") do |format|
      format.html { render layout: "recall" }
      format.text { render layout: "recall" }
    end
  end
  def incident_report(name, email, tuid, phone, affiliation, department, pickup_location, cancel_by, title, author, callnum, comments, subsitute_edition)
    @body = ""
    @body << "Name: " + name.to_s + "<br>"
    @body << "Email: " + email.to_s + "<br>"
    @body << "TUid: " + tuid.to_s + "<br>"
    @body << "Phone: " + phone.to_s + "<br>"
    @body << "Affiliation: " + affiliation.to_s + "<br>"
    @body << "Department: " + department.to_s + "<br>"
    @body << "Pickup Location: " + pickup_location.to_s + "<br>"
    @body << "Cancel by: " + cancel_by.to_s + "<br>"
    @body << "Title: " + title.to_s + "<br>"
    @body << "Author: " + author.to_s + "<br>"
    @body << "Call Number: " + callnum.to_s + "<br>"
    @body << "Comments: " + comments.to_s + "<br>"
    @body << "Substitute Edition?: " + subsitute_edition.to_s + "<br>"
    mail(to: "cdoyle@temple.edu", subject: "Recall Request") do |format|
      format.html { render layout: "recall" }
      format.text { render layout: "recall" }
    end
  end
  def missing_book(name, email, tuid, phone, affiliation, department, pickup_location, cancel_by, title, author, callnum, comments, subsitute_edition)
    @body = ""
    @body << "Name: " + name.to_s + "<br>"
    @body << "Email: " + email.to_s + "<br>"
    @body << "TUid: " + tuid.to_s + "<br>"
    @body << "Phone: " + phone.to_s + "<br>"
    @body << "Affiliation: " + affiliation.to_s + "<br>"
    @body << "Department: " + department.to_s + "<br>"
    @body << "Pickup Location: " + pickup_location.to_s + "<br>"
    @body << "Cancel by: " + cancel_by.to_s + "<br>"
    @body << "Title: " + title.to_s + "<br>"
    @body << "Author: " + author.to_s + "<br>"
    @body << "Call Number: " + callnum.to_s + "<br>"
    @body << "Comments: " + comments.to_s + "<br>"
    @body << "Substitute Edition?: " + subsitute_edition.to_s + "<br>"
    mail(to: "cdoyle@temple.edu", subject: "Recall Request") do |format|
      format.html { render layout: "recall" }
      format.text { render layout: "recall" }
    end
  end

  def recall(name, email, tuid, phone, affiliation, department, pickup_location, cancel_by, title, author, callnum, comments, subsitute_edition)
    @body = ""
    @body << "Name: " + name.to_s + "<br>"
    @body << "Email: " + email.to_s + "<br>"
    @body << "TUid: " + tuid.to_s + "<br>"
    @body << "Phone: " + phone.to_s + "<br>"
    @body << "Affiliation: " + affiliation.to_s + "<br>"
    @body << "Department: " + department.to_s + "<br>"
    @body << "Pickup Location: " + pickup_location.to_s + "<br>"
    @body << "Cancel by: " + cancel_by.to_s + "<br>"
    @body << "Title: " + title.to_s + "<br>"
    @body << "Author: " + author.to_s + "<br>"
    @body << "Call Number: " + callnum.to_s + "<br>"
    @body << "Comments: " + comments.to_s + "<br>"
    @body << "Substitute Edition?: " + subsitute_edition.to_s + "<br>"
    mail(to: "cdoyle@temple.edu", subject: "Recall Request") do |format|
      format.html { render layout: "recall" }
      format.text { render layout: "recall" }
    end
  end
end
