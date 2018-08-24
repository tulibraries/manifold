* `# README

Fortytude is an object oriented based website for the Temple University Libraries.

##  Getting Started

* Clone the repository and navigate to the souce code directory

```
git clone git@github.com:tulibraries/fortytude.git`
`cd fortytude
```

* Install dependencies

```
bundle install
```

* Create data tables

```
bundle exec rake db:migrate
```

* Populate the database with fake data

```
bundle exec rake db:populate
```

* Seed initial user from the command line

```
rails runner 'Account.create(email: "<YOURTUACCESSID>@temple.edu", admin: true, password: Devise.friendly_token[0,20]).save'
```

* *Or* create an account seed file with a list of the initial TUAccess ID's of the
admin users. Set the `admin` field to true if the user will have the role of a site user
administor, capable of adding and deleting admin users.

```
mv db/account_seeds.rb.example db/account_seeds.rb
```

Edit `db/account_seeds.rb`, Replace contents of email array with the desired email addresses

* Seed the user admin accounts

```
bundle exec rake db:seed
```

* Test the code

```
bundle exec rspec spec
```

* Run the application

```
bundle exec rails server
```

* On your browser, navigate to `http:localhost:3000`.

* To administer site objects, navigate to: `http://localhost:3000/admin`

You will be redirected to the Temple University Google OAuth site. Log in with your TUAccess ID credentials and the
browser will return to the site administration home page.

## Test the code

To test the code, run the RSpec tests.

```
bundle exec rspec spec
```

To run continuous testing which will run the appropirate specs as you save
source code, execute Guard

```
guard
```

To perform mutation tests, which helps gage code coverage and test soundness on a class by class basis
run mutant as below.  Available class names are:

* Building
* Space
* Person
* Group
* BuildingsController
* SpacesController
* PersonsController
* GroupsController

Note: Class names are case sensitive and in pluralized in controller.

```
RAILS_ENV=test bundle exec mutant -j 1 -r ./config/environment --use rspec <class name>
```

For more information on mutation testing, see https://github.com/mbj/mutant.
