# manifold
*adj.* - **many and varied**

manifold manages, orchestrates, and displays data about Temple University Libraries.

## System Requirements

- Ruby 2.5.1
- Postgres >= 9.5 

##  Getting Started

* Set up environment variables:

```
export GOOGLE_OAUTH_CLIENT_ID="Google client ID goes here"
export GOOGLE_OAUTH_SECRET="Google OAuth secret goes here"
```

Add these same lines to your `.bash_profile` or `.bashrc` file, depending on
how you've setup your Bash shell.

* Clone the repository and navigate to the souce code directory

```
git clone git@github.com:tulibraries/manifold.git
cd manifold
```

* Install dependencies

```
bundle install
```

* Install JSON validation tool

```
sudo apt-get -y install npm
sudo npm install -g ajv
sudo npm install -g ajv-cli
```

* Create database tables

```
bundle exec rake db:migrate
```

* Populate the database with fake data

```
bundle exec rake db:populate
```

* Seed initial user from the command line. Note that the email address should be a TUAccess email address.
Aliased email addresses will not work.

```
rails runner 'Account.create(email: "<YOURTUACCESSID>@temple.edu", admin: true, password: Devise.friendly_token[0,20]).save'
```

If this application will be running in development mode and you wish to use standard authentication, seed the initial user
with an email address and password.

```
rails runner 'Account.create(email: "admin_user@example.com", admin: true, password: "initial_password_goes_here").save'
```

Add additional users with this method, as the account admin page is configured for administering users in a production environment. Set the admin field to true to allow this user to administer users, otherwise it defaults to non-admin

```
# Regular user
rails runner 'Account.create(email: "regular_user@example.com", admin: false, password: "initial_password_goes_here").save'
# Admin user
rails runner 'Account.create(email: "admin_user@example.com", admin: true, password: "initial_password_goes_here").save'
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

## Setting up Postgres on your local machine

You'll need a running Postgres >= 9.5 on your local dev machine.

### Installing on OSX

Install with homebrew

```bash
brew install postgres
```

Next, set up postgres to run as a service

```bash
brew services postgres start
```

### Installing on Ubuntu

Install with apt
```bash
sudo apt-get install postgresql-server
```

`apt-get` should set up postgres as a service.



### Create a postgres user (OSX and Ubuntu)
Finally, we need to create a postgres role with enough privileges to create and destroy databases. We'll use the built in `createuser` command with the `-d` flag that allows the user to create and destroy databases, and the `-W` flag that will cause the command to prompt your for a password, which is just `password`.

```bash
$ createuser -dW manifold
Password: #now enter your password
```



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

To perform mutation tests, which helps guage code coverage and test soundness on a class by class basis
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
