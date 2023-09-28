# manifold
*adj.* - **many and varied**

manifold manages, orchestrates, and displays data about Temple University Libraries.

## System Requirements

- Ruby, see Gemfile for latest version
- Postgres >= 9.5
- ImageMagick

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

* Create database tables

```
bundle exec rails db:migrate
 ```

* Seed initial user from the command line. Note that the email address should be a TUAccess email address.
Aliased email addresses will not work.

```
rails runner 'Account.create(name: "YOUR_NAME", email: "<YOURTUACCESSID>@temple.edu", admin: true, password: Devise.friendly_token[0,20]).save'
```

If this application will be running in development mode and you wish to use standard authentication, seed the initial user
with an email address and password.

```
rails runner 'Account.create(name: "Admin", email: "admin_user@example.com", admin: true, password: "initial_password_goes_here").save'
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
bin/dev
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
brew services start postgres
```

### Installing on Ubuntu

Install with postgres and development library via apt
```bash
sudo apt-get install postgresql-server libpq-dev
```

`apt-get` should set up postgres as a service.



### Create a postgres user
Finally, we need to create a postgres role with enough privileges to create and destroy databases. We'll use the built in `createuser` command with the `-d` flag that allows the user to create and destroy databases, and the `-W` flag that will cause the command to prompt your for a password, which is just `password`.

#### OSX

```bash
$ createuser -dW manifold
Password: #now enter your password
```

#### Ubuntu
On ubunutu, we need to run commands as the postgres users
```bash
$ sudo su -c "createuser -dW manifold" postgres
Password: #now enter your password
```

## Running with production data locally

We will occassionally dump out data from the produciton postgres DB that you can import locally to have a reasonably up to date version of data for local development.

Once you have the postgres dump file (self-service location tbd) created with pg_dump, you can import it into your local postgres instance:

```bash
# First drop the existing db
bundle exec rails db:drop

# then recreate an empty db
bundle exec rails db:setup

# finally import the data

# on OSX, it should just work as your user
pg_restore -c --dbname=manifold_development /path/to/postgres_dump_file

# on Linux, you probably have to run as the postgres user
sudo su postgres -c "pg_restore -c --dbname=manifold_development /path/to/postgres_dump_file"


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

## Clean Up

Clean up existing people database, which may contain blank specialties, by stepping through
each record and updating the specialties record.

```
$ bundle exec rails console

> Person.all.each { |p| p.update(specialties: p[:specialties]) unless p.specialties.nil? }
> exit
```

## Swagger API definition and Api Docs

A `swagger.json` file is served from the root of the application that describes API enpoints that are available.

We have also included autogenerated Swagger API Docs, that are available at `/api-docs/`, which provide an overview of the Endpoints available, the expected response schema, available parameters, etc.



## Generating a Site Map

Sitemap generation is configured in `config/sitemap.rb` it contains logic to create links to the default set of show pages. Special page one-off pages would be added to this file similar to:

```ruby
  add '/about'
  add '/visit-us'
```

To generate a sitemap, execute the following command:

```bash
bundle exec rails sitemap:create
```

## Draftable Fields

Admin users may draft changes to description fields. This feature is not enabled by default. To enable, set the `MANIFOLD_DRAFTABLE` environment variable to `"true"`. This can
be done from the shell

```bash
export MANIFOLD_DRAFTABLE=true
```

or command line for developement:

```bash
MANIFOLD_DRAFTABLE=true bin/dev
```
