# Converter

 * Dependencies: python3, [peewee](http://docs.peewee-orm.com/en/latest/)
 * Needs a dump of the current Klausurtool
  * Create via ```mysqldump --compatible=ansi --skip-extended-insert --compact```
  * Remove all "AUTO_INCREMENT"
  * Import into file called ```og.sqlite3```: 
   * ```sqlite3 og.sqlite3``` 
   * ```.read dump.sql```
 * Needs a clean database in ```../db/development.sqlite3```: ```rake db:schema:load``` and then run ```python converter.py``` 

Current conversion (2016-01-08) takes around 12 minutes on a computer 
with Intel(R) Core(TM) i7-4770K CPU @ 3.50GHz and 8GB RAM
