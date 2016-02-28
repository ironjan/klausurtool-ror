# 0.1.0

 * [LDAP access via SSH-tunnel ermöglicht das Umwandeln von IMT-Logins in Klarnamen](https://github.com/ironjan/klausurtool-ror/issues/63)
 * [Delete-Actions repariert (diese wurden von jQuery bereitgestellt, welches zuvor entfernt wurde](https://github.com/ironjan/klausurtool-ror/issues/88)
 * [False positives beim Erkennen von fehlerhaften Datumsangaben in der Datenbank durch Fixen der Datenbank behoben](https://github.com/ironjan/klausurtool-ror/issues/106)
 * [Fixed #108](https://github.com/ironjan/klausurtool-ror/issues/108)
 * [Fixed #116: Firefox date picker](https://github.com/ironjan/klausurtool-ror/issues/116)
 

# 0.0.16

 * [Fixed: HTTP 500, wenn Verleih-Formular fehlerhaft aufgerufen wurde](https://github.com/ironjan/klausurtool-ror/issues/55)
 * [Admin-UI aufgeräumt](https://github.com/ironjan/klausurtool-ror/issues/7)
 * [Replaced jQuery by Vanilla JavaScript](https://github.com/ironjan/klausurtool-ror/issues/47),
 * Allgemeine Code Cleanup Tasks: [#6](https://github.com/ironjan/klausurtool-ror/issues/6), 
                                  [#74](https://github.com/ironjan/klausurtool-ror/issues/74),
                                  [#78](https://github.com/ironjan/klausurtool-ror/issues/78),
                                  [#93](https://github.com/ironjan/klausurtool-ror/issues/93)

# 0.0.15

 * [Erinnerung beim Verleihen hinzugefügt](https://github.com/ironjan/klausurtool-ror/issues/67)
 * [Fixed: Größe der JavaScript-Dateien stark reduziert](https://github.com/ironjan/klausurtool-ror/issues/47)
 * [Fixed: Bug im Backend beim Auflisten der Ordner mit kaputten Namen](https://github.com/ironjan/klausurtool-ror/issues/86)
 * Code-Clean up: [#6](https://github.com/ironjan/klausurtool-ror/issues/6) und weitere
 * Mehr Tests, um Regressions zu vermeiden
 * Kleinere Bugs behoben, die es nicht ins Live-System geschafft haben

# 0.0.14

 * Updated production assets

# 0.0.13

 * Fixed: Javascript-Dateien waren áuf production nicht aktualisiert; dies wurde nachgeholt.
 * [Workaround: fehlender UTF-8-Support in SQLITE wird durch Einfügen von Wildcards umgangen](https://github.com/ironjan/klausurtool-ror/issues/64)
 * [Fixed: Fehlerhafte Feedback-Nachricht beim Verleihen](https://github.com/ironjan/klausurtool-ror/issues/66)
 * [Fixed: Unvollständige Liste für Ordner mit fehlerhaftem Encoding](https://github.com/ironjan/klausurtool-ror/issues/)
 * [Fixed: Barcodes auf bestimmten Ordnern wurden korrekt als fehlerhaft erkannt, kleben aber nun mal so auf den Ordnern :/](https://github.com/ironjan/klausurtool-ror/issues/49)

# 0.0.12

 * [Fixed: Ordner-Details in Admin-Bereich gefixt](https://github.com/ironjan/klausurtool-ror/issues/65)

# 0.0.11

 * [Fixed: Imt-Login, Name des Studenten und Pfand zum Zurücknehm-Formular hinzugefügt](https://github.com/ironjan/klausurtool-ror/issues/69)

# 0.0.10

 * [Fixed: Erstes Feld in Forms wird fokussiert](https://github.com/ironjan/klausurtool-ror/issues/1 )
 * [Barcode-Erkennung verbessert](https://github.com/ironjan/klausurtool-ror/issues/37)
 * [Hinzugefügt: Auto-Completion für existierende Profs beim Anlegen von Prüfungen](https://github.com/ironjan/klausurtool-ror/issues/42)
 * Verbessert: Flash-Messages sind klickbar und schließen sich nach einer Minute automatisch 
  [#39](https://github.com/ironjan/klausurtool-ror/issues/39) 
  [#40](https://github.com/ironjan/klausurtool-ror/issues/40)
  [#47](https://github.com/ironjan/klausurtool-ror/issues/47)
 * [Fixed: man konnte beim Verleihen Daten eintragen, die zu einem HTTP500 geführt haben](https://github.com/ironjan/klausurtool-ror/issues/51)

# 0.0.9

 * Logging für Docker angepasst

# 0.0.8

 * [Fixed: Suche zeigte manchmal keine Resultate](https://github.com/ironjan/klausurtool-ror/issues/26)
 * [Fixed: Ausleih-Archiv wird absteigend nach Rückgabe-Datum sortiert](https://github.com/ironjan/klausurtool-ror/issues/23)
 
# 0.0.7

 * [Fixed: Verleiher und Gewicht werden beim Zurücknehmen angezeigt](https://github.com/ironjan/klausurtool-ror/issues/19)

# 0.0.6

 * [Fixed: Assets wurden im production mode nicht ausgeliefert](https://github.com/ironjan/klausurtool-ror/issues/12)

# 0.0.5

 * [Fixed: Version number now points to Changelog](https://git.cs.upb.de/ljan/klausurtool-ror/issues/14)
 * Fixed: Internal server error for empty searches
 * Cleaned up Code

# 0.0.4

 * Added: CHANGELOG
 * Added: UI to quickly fix broken encodings and dates
 * Fixed: Spaces are used as wildcards in searchs
 * Fixed: Buttons when lending and receiving are now the same as in og
 * Fixed: Wrong Button in an edit form
