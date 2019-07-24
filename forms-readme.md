# Form Creation Steps

Forms consist of rails form partials that provide a title, information
about the form, and the form fields.  The form fields will provide
attributes in the form model.

Note - The form name is denoted `<form_name>`

- Open form model file `app/models/form.rb` in a text editor.

- Add the name of the form to the `@forms` hash in the `get_subject` method.

  ```
  def get_subject
    @forms = {
      "requested-book" => ["Request Book", "cdoyle@temple.edu"],
      "recall-book" => ["Request Recall of Books Already Checked Out",  "cdoyle@temple.edu"],
      "purchase-request" => ["Purchase Request",  "cdoyle@temple.edu"],
      "ask-scrc" => ["Special Collections Research Center: Ask a Question", "cdoyle@temple.edu"] }

    @forms.fetch(form_type)
  end
  ```

- Create a directory to contain the form template

  ```
  mkdir -p app/views/forms/<form_name>
  ```

- Add an entry in `/config/locales/en.yml` under the `forms` key, using the form_name as
a key, with a title key containing the human readable name of the form, as in the example below.

  ```
  ...
  forms:
    recall_book:
      title: Request Recall of Books Already Checked Out
    purchase_request:
      title: Purchase Request
  ...
  ```

- Create an intro partial template file `app/views/forms/<form_name>/_intro.html.erb`
and add the introductory text.

  ```
  Use this form to request books be placed on hold under your name
  ```

- Create a request information partial template file

  `app/views/forms/<form_name>/_request-info.html.erb`
  and add the form input fields in `_request-info.html.erb`. For each form
  input, create an attribute in `manifold/app/models/form.rb` with all of the
  other attributes. See below for examples of both:

  *Form Partial*

  ```
  <%= f.input :author, label: "Author", required: true %>
  <%= f.input :title, label: "Title", required: true %>
  <%= f.input :year, required: true %>
  <%= f.input :affiliation, label: "Affiliation", as: :radio_buttons, collection: ["TU Student", "TU Faculty or Staff", "Library Student Assistant", "Library Staff", "Visitor/Guest"], required: :true %>
  <%= f.input :pickup_location, as: :radio_buttons, collection: ["Paley","Ambler","Harrisburg"], required: :true %>
  <%= f.input :needed_date, as: :date, start_year: Date.today.year, end_year: Date.today.year+1, order: [:month, :day, :year], required: :true %>
  ```

  *Form model attribute*

  ```
  attribute :cancellation_date
  ```
