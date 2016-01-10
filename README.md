= Getting started

 * Install Ruby on Rails
  * Check that ruby and sqlite3 are installed
   * ```ruby -v``` ruby 2.3.0p0
   * ```sqlite3 --version```
  * Install Rails: ```gem install rails```
   * Add the rails bin-directory to your path 
 * Install dependencies via ```bundle install```
  * If you don't have sudo access, you can install the gems to a path of your choice via e.g. ```bundle install --path $HOME/bundle/```
 * Create the db:schema via ```bin/rake db:schema:load```
  * In development mode, RoR will tell you, when migrations need to be run via ```bin/rake db:migrate```
 * Start the server via ```bin/rails server```
  * The ```-e``` switch can be used to start a server in a different environment
  * Start with ```bin/rails server --binding 0.0.0.0``` to listen to external requests
   * This does not automatically mean "production mode"
   * More information will be added later

= Next steps

 * Extract embedded forms:
  * http://0.0.0.0:3000/admin/old_folders/1 - new instance
  * http://0.0.0.0:3000/admin/old_folders/1 - new exam
 * Merge ```ausleihe#lent``` and ```admin_lend_outs#lent``` (and also ```*.history```) - perhaps into "concerns"?
 * Fix instances controller new: error when number exists.
 * Fix: delete folder_instance -> show folder
 * Fix: old_exams_controller#update error handling: what if update fails when coming from folder?
 * Search for TODO ;)
 * http://berk.es/2011/03/29/simplest-authentication-in-rails-basic-authentication-with-a-logged_in-helper/
   * For editing methods...
 * Suche nach Ordnern
 * Fix: Show errors in embedded forms (Create exam from folder)
 * old_lend_outs_controller "# Fixme Use transaction with post validation that lending was correct"
 * Ausleih-Archiv
 * Deckblätter u.ä. generieren
 
= TODO for README

 * Ruby version
 * Rails version
 
= Links that helped

Incomplete list, started to write these down in the middle of the project. 

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
 * http://www.mediaevent.de/xhtml/html-section-header.html
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