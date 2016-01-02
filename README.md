= Getting started

 * ```bundle install```
 * ```bin/rails server```

= Next steps

 * Make http://0.0.0.0:3000/ausleihe/folders and http://0.0.0.0:3000/ausleihe/folders readable
 * Add Suchen to Ausleihe
 * Show search query in /old_exams if present as parameter, see ausleihe#index
 * http://0.0.0.0:3000/ausleihe/list -> http://0.0.0.0:3000/ausleihe/lent
 * Fix instances controller new
 * Fix: delete folder_instance -> show folder
 * Fix: old_exams_controller#update error handling: what if update fails when coming from folder?
 * http://berk.es/2011/03/29/simplest-authentication-in-rails-basic-authentication-with-a-logged_in-helper/
   * For editing methods...
 * Suche nach Ordnern
 * Fix: Show errors in embedded forms (Create exam from folder)
 * old_lend_outs_controller "# Fixme Use transaction with post validation that lending was correct"
 * Deckblätter u.ä. generieren
 
= TODO for README

 * Ruby version
 * Rails version
 
= Links that helped

Incomplete list, started to write these down in the middle of the project. 

 * Rails Getting Started
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