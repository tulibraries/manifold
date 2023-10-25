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
      "requested-book" => ["Request Book", "someone@temple.edu"],
      "recall-book" => ["Request Recall of Books Already Checked Out",  "someone@temple.edu"],
      "purchase-request" => ["Purchase Request",  "someone@temple.edu"],
      "ask-scrc" => ["Special Collections Research Center: Ask a Question", "someone@temple.edu"] }

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

## Form Persistence

All form submissions are persisted to the database in the `form_submissions` table. As these forms can contain sensitive data, they are encrypted before they are stored in the DB, requiring the same key to decrypt. The key is picked up from `$LOCKBOX_MASTER_KEY` environment variable.


## Testing Forms

All Forms should be tested with the `email form` shared example.

The `email form` shared example requires you to define two variables via `let`
* `form_type` - the url path / template path of the form, like `missing-book`
* `form_params` - a hash of params that represent data sent to the form when someone submits it. The `name` and `email` params are included by default; this just needs to include params specific to this form.


`/spec/request/forms/recall_book_spec.rb`
```
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Recall Book Form", type: :request do

  let(:form_type) { "recall-book" }
  let(:form_params) {
    {
      phone: "1234567890", tu_id: "test_id", department: "test dept",
      affiliation: "Staff", author: "test author", title: "test title",
      call_number: "test call number", substitute_edition: "false",
      pickup_location: "Ambler"
    }
  }

  it_behaves_like "email form"

end
```
