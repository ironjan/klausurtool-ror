# Klausurtool RoR

[![Codacy Badge](https://api.codacy.com/project/badge/grade/dd4147004f17412f96893e99d90d1245)](https://www.codacy.com/app/lippertsjan/klausurtool-ror)


## Fehler melden, Feedback geben

 * Sieh dann unter https://github.com/ironjan/klausurtool-ror/issues nach, ob das Feedback oder Problem bereits bekannt wird
 * Falls es nicht nicht bekannt ist, erstelle einen neuen Issue
  * Sei bitte so ausführlich wie möglich
  * Falls es um eine bestimmte Seite im Tool geht, bitte URL mit einfügen


## Getting started

 * Install Ruby on Rails
  * Check that ruby and sqlite3 are installed
   * ```ruby -v``` ruby 2.3.0p0
   * ```sqlite3 --version```
  * Install Rails: ```gem install rails```
   * Add the rails bin-directory to your path 
   * Currently, rails 4.2.4 is used
  * Other requirements: ```git``` and ```sed```
 * Install dependencies via ```bundle install```
  * If you don't have sudo access, you can install the gems to a path of your choice via e.g. ```bundle install --path $HOME/bundle/```
 * Copy ```config/secrets.yml.template``` to ```config/secrets.yml``` and generate different values for secret_key_base (You can use ```bin/rake secret```)
 * Create the db:schema via ```bin/rake db:schema:load```
  * In development mode, RoR will tell you, when migrations need to be run via ```bin/rake db:migrate```
 * Start the server via ```bin/rails server```
  * The ```-e``` switch can be used to start a server in a different environment
  * Start with ```bin/rails server --binding 0.0.0.0``` to listen to external requests
   * This does not automatically mean "production mode"
   * More information will be added later
 * Pre-Compile assets for production via ```RAILS_ENV=production bin/rake assets:precompile```


## Versioing

 * Follows [Semantic Versioning](http://semver.org/)
 * Uses http://stackoverflow.com/questions/9073446/where-do-you-store-your-rails-applications-version-number to update version
  * ```git tag $version``` & restart server
 * The [Milestones](https://github.com/ironjan/klausurtool-ror/milestones) of this project are named in a more or less funny way
  * They are more or less used as orientation on what to work next.


## Links that helped to get started

The goal of this list is to collect links that helped me Getting started. It was started in the middle of the project and is therefore incomplete.

 * [Rails Getting Started](http://guides.rubyonrails.org/getting_started.html)
 * http://www.korenlc.com/creating-a-simple-search-in-rails-4/
 * http://www.dotnetperls.com/sub-ruby
 * http://stackoverflow.com/questions/6551128/split-on-different-newlines
 * http://stackoverflow.com/questions/5878697/how-do-i-remove-blank-elements-from-an-array
 * http://www.eriktrautman.com/posts/ruby-explained-map-select-and-other-enumerable-methods
 * http://edgeguides.rubyonrails.org/active_record_migrations.html#creating-a-join-table
 * http://blog.teamtreehouse.com/ruby-arrays
 * http://stackoverflow.com/questions/2831059/how-to-drop-columns-using-rails-migration
 * http://makandracards.com/makandra/31937-differences-between-transactions-and-locking
 * http://stackoverflow.com/questions/19690687/check-if-multi-insert-transaction-is-successful-or-not
 * http://guides.rubyonrails.org/layouts_and_rendering.html
 * http://stackoverflow.com/questions/185965/how-do-i-change-the-title-of-a-page-in-rails
 * http://stackoverflow.com/questions/3025784/rails-layouts-per-action
 * http://stackoverflow.com/a/23066966/1666181
 * http://ruby-doc.org/
 * http://www.mediaevent.de/xhtml/htmtl-section-header.html
 * http://railsguides.net/change-data-in-migrations-like-a-boss/
 * http://stackoverflow.com/questions/4282710/how-do-i-describe-an-enumeration-column-in-a-rails-3-migration
 * http://stackoverflow.com/questions/23686265/saving-enum-from-select-in-rails-4-1
 * http://joanswork.com/localized-activerecordenum-display-names/
 * http://guides.rubyonrails.org/i18n.html
 * http://maxdesign.com.au/articles/definition/
 * https://github.com/twbs/bootstrap-sass
 * http://bootcards.org/
 * http://stackoverflow.com/questions/19622056/include-bootstrap-role-attribute-in-rails-form-helper
 * http://v4-alpha.getbootstrap.com/components/forms/#form-layouts
 * http://www.w3schools.com/bootstrap/
 * http://stackoverflow.com/questions/10691442/adding-a-simple-spacer-to-twitter-bootstrap
 * http://stackoverflow.com/questions/9282689/allow-public-connections-to-local-ruby-on-rails-development-server
 * http://stackoverflow.com/questions/18000037/rails-how-to-handle-existing-invalid-dates-in-database
 * Testing:
  * http://everydayrails.com/2012/03/19/testing-series-rspec-models-factory-girl.html
  * http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  * https://www.relishapp.com/rspec/rspec-mocks/docs
