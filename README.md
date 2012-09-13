# Heploy

Deploying your Rails application to Heroku is easy. Managing development, staging and production branches and servers is a bit more annoying. Creating backups. Migrating your database. Flipping the maintenance switch on and off. All a little bit more annoying.

So Heploy does that for you. And for me. Instead of going down your long list of deploy checkboxes, let Heploy do it.

(NOTE: I'm going for Readme Driven Development here, so not everything will be ready right away.)

## Installation

Add this line to your application's Gemfile:

    gem 'heploy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heploy

Then run the installer:

    $ rails g heploy:install

You'll have to fill out the configuration file with some application details and your Heroku information.

Bonus! Add an alias:

    alias deploy='bundle exec heploy'

Enjoy typing `$ deploy staging` instead of `$ bundle exec heploy staging` all the time.

## Usage

I'm trying to keep this is simple as possible.

### Basic usage

Heploy defaults to you using a "dev", "staging" and "production" branch. You can change the defaults in the configuration file. But for now, here we go.

Deploying to staging:

    $ bundle exec heploy staging

Deploying to production:

    $ bundle exec heploy production

Simple.

### What's going on?

Let's start with `$ heploy staging`. When you run it, you:

1. Merge "dev" branch into "staging".
2. Creates a backup of the database, using the PG Backups add-on.
3. Tags the current release as "staging-26" (or whatever your Heroku release number is).
4. Flips Heroku maintenance on.
5. Pushes the "staging" branch to your Heroku staging server.
6. Runs any recent database migrations.
7. Restarts the server.
8. Turns maintenace off.

As you might have guessed, `$ heploy production` does pretty much the same thing, except merges the "staging" branch into "production".

### Other things

Heploy can also help set up your staging and production environments.

Your production and staging environments should be as similiar as possible. To help with this, you can compare the two environments to see if anything needs to be changed.

    $ heploy compare

This doesn't actually change anything. It just gives you an overview.

## Contributing

1. Fork it.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create new Pull Request.
