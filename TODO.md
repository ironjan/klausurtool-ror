 * Dump production database
 * Execute `data_conversion_0.6.6_to_0.7.0.sql` on production
 * Execute `find_potentially_unarchived_lend_outs.sql` on production
  * Update and rename `fix_unarchived_lendouts_20161109.sql` if necessary
 * Execute `fix_unarchived_lendouts_20161109.sql` on production
  * Optional: Delete this fix
 * Go to [[http://ausleihe.fachschafts.website/internal/ausleihe/returning_form?old_folder_instances%5B%5D=33]], i.e. return the "missing" folders
 * Delete the following folder instances:
  * [http://ausleihe.fachschafts.website/internal/admin/old_folder_instances?utf8=✓&search=1261&commit=Suche](1261, Modellierung)
  * [http://ausleihe.fachschafts.website/internal/admin/old_folder_instances?utf8=✓&search=1342&commit=Suche](1342, Stochastik (Info))
 * Create issue: Embed http://yui.yahooapis.com/pure/0.6.0/pure-min.css in klausurtool -> offline layouting
 
