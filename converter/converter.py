from peewee import *
from playhouse.sqlite_ext import SqliteExtDatabase
import datetime
import requests

class OldModel(Model):
    class Meta:
        database = SqliteExtDatabase('og.sqlite3')

class Ausleihe(OldModel):
  ausleihID = IntegerField(primary_key=True)
  gewicht   = IntegerField()
  status    = IntegerField()
  datumRaus = DateTimeField()
  datumRein = DateTimeField()
  raus      = CharField()
  rein      = CharField()
  pfand     = CharField()
  name      = CharField()

class Inhalt(OldModel):
  inhaltID = IntegerField(primary_key=True)
  name     = CharField()
  dozent   = CharField()
  datum    = DateTimeField()
  seiten   = IntegerField()
  muster   = CharField()
  scanned  = CharField()
  scannID  = IntegerField()

class Ordner(OldModel):
  ordnerID   = IntegerField(primary_key=True)
  title      = CharField()
  typ        = IntegerField()
  anz        = IntegerField()
  farbe      = IntegerField()
  gebiet     = IntegerField()
  archiviert = DateTimeField()
  scanned    = IntegerField()

class Ordner_Inhalt(OldModel):
  id       = IntegerField(primary_key=True)
  ordnerID = IntegerField()
  inhaltID = IntegerField()

class Ausleihe_Ordner(OldModel):
  ausleihID    = IntegerField(primary_key=True)
  ordnerID     = IntegerField()
  ordnerNummer = IntegerField()

class RorModel(Model):
    class Meta:
        database = SqliteExtDatabase('../db/development.sqlite3')


class Old_Folders(RorModel):
  title       = CharField()
  contentType = CharField()
  area        = CharField()
  created_at  = DateTimeField(default=datetime.datetime.now)
  updated_at  = DateTimeField(default=datetime.datetime.now)
  color       = IntegerField()

class Old_Folder_Instances(RorModel):
  number          = IntegerField()
  old_folder      = ForeignKeyField(Old_Folders)
  barcodeId       = CharField()
  created_at      = DateTimeField(default=datetime.datetime.now)
  updated_at      = DateTimeField(default=datetime.datetime.now)
  old_lend_out_id = IntegerField()

class Old_Exams(RorModel):
  title      = CharField()
  examiners  = CharField()
  date       = DateTimeField()
  created_at = DateTimeField(default=datetime.datetime.now)
  updated_at = DateTimeField(default=datetime.datetime.now)
  old_folder = ForeignKeyField(Old_Folders)

class Old_Lend_Outs(RorModel):
  deposit       = CharField()
  imt           = CharField()
  lender        = CharField()
  receiver      = CharField()
  lendingTime   = DateTimeField() 
  receivingTime = DateTimeField()
  weigth        = IntegerField()
  created_at    = DateTimeField(default=datetime.datetime.now)
  updated_at    = DateTimeField(default=datetime.datetime.now)

class Archived_Old_Lend_Outs(RorModel):
  deposit       = CharField()
  imt           = CharField()
  lender        = CharField()
  receiver      = CharField()
  lendingTime   = DateTimeField() 
  receivingTime = DateTimeField()
  weigth        = IntegerField()
  created_at    = DateTimeField(default=datetime.datetime.now)
  updated_at    = DateTimeField(default=datetime.datetime.now)

class Archived_Old_Lend_Outs_Old_Folder_Instances(RorModel):
  archived_old_lend_out_id = IntegerField()
  old_folder_instance_id = IntegerField()

  class Meta:
    primary_key = CompositeKey('archived_old_lend_out_id', 'old_folder_instance_id')


def OrdnerToOldFolder(ordner):
  old_folder = Old_Folders(
    id = ordner.ordnerID, 
    title = ordner.title,
    contentType = {
        0: "Klausurordner",
        1: "Klausurmappe",
        2: "Pruefungsprotokollordner",
        3: "Pruefungsprotokollmappe",
        4: "Übungsblätter", 
        5: "Sonstiges"
    }.get(ordner.typ, "Sonstiges"),
    color = ordner.farbe,
    area = {
      0: "ESS", 
      1: "MMWW", 
      2: "SWT", 
      3: "MUA",
      4: "Grundst. Info", 
      5: "Mathe", 
      6: "Sonstiges"
    }.get(ordner.gebiet, "Sonstiges"))
  return old_folder

def createOldFolderInstancesFor(ror, count):
  number = 1
  old_folder_id = ror.id
  while number <= count:
    instance = Old_Folder_Instances(number = number,
      old_folder_id = old_folder_id,
      barcodeId = "%03d%d" % (old_folder_id, number),
      old_folder = ror
      )
    instance.save()
    print("Created %s(%s, %s, %s)" % (instance.old_folder.id, instance.old_folder_id, instance.number, instance.barcodeId))
    number += 1


def InhaltToOldExam(inhalt):
  old_exam = Old_Exams(
    id = inhalt.inhaltID,
    title = inhalt.name,
    examiners = inhalt.dozent,
    date = inhalt.datum
    )
  return old_exam

def AusleiheToLendOut(ausleihe):
  lendout = None
  if ausleihe.datumRein == None:
    lendout = Old_Lend_Outs()
    print(" Old_Lend_Outs()")
  else:
    lendout = Archived_Old_Lend_Outs()
    print(" Archived_Old_Lend_Outs()")
  lendout.id            = ausleihe.ausleihID
  lendout.deposit       = ausleihe.pfand
  lendout.imt           = ausleihe.name
  lendout.lender        = ausleihe.raus
  lendout.receiver      = ausleihe.rein
  lendout.lendingTime   = ausleihe.datumRaus
  lendout.receivingTime = ausleihe.datumRein
  lendout.weigth        = ausleihe.gewicht
  print("  (%d, %s, %s, %dg, %s, %s, %s, %s)" % 
    (lendout.id, lendout.deposit, lendout.imt, lendout.weigth,
      lendout.lender, lendout.lendingTime, 
      lendout.receiver, lendout.receivingTime))
  return lendout
  
def createDefaultFolder():
  defaultFolder = Old_Folders(
      title = "Unzugeordnete Prüfungen",
      contentType = "Sonstiges",
      color = 0,
      area = "Sonstiges")
  defaultFolder.save();
  print("Created defaultFolder (%s)" % defaultFolder.id)
  instance = Old_Folder_Instances(number = 1,
      old_folder_id = defaultFolder.id,
      barcodeId = "%03d%d" % (defaultFolder.id, 1),
      old_folder = defaultFolder
      )
  instance.save()
  print("Created instance %s(%s, %s, %s)" % (instance.old_folder.id, instance.old_folder_id, instance.number, instance.barcodeId))
  return defaultFolder


def convertFolders():
  convertedFolders = 0
  for ordner in Ordner.select():
    old_folder = OrdnerToOldFolder(ordner)
    convertedFolders += old_folder.save(force_insert=True)
    print("Saved (%s, %s)" % (old_folder.id, old_folder.title))
    createOldFolderInstancesFor(old_folder, ordner.anz)
  
  print("Converted %d/%d folders" % (convertedFolders, Ordner.select().count()))



def convertExams(defaultFolder):
  convertedExams = 0
  for inhalt in Inhalt.select():
    old_exam = InhaltToOldExam(inhalt)
    print("Converting Inhalt %s" % inhalt.inhaltID)
    oi = Ordner_Inhalt.select().where(Ordner_Inhalt.inhaltID == inhalt.inhaltID).first()
    if oi == None:
      old_exam.old_folder = defaultFolder
    else:
      old_folder = Old_Folders.select().where(Old_Folders.id == oi.ordnerID).first()
      if old_folder == None:
        old_exam.old_folder = defaultFolder
      else:
        old_exam.old_folder = old_folder
    
    convertedExams += old_exam.save(force_insert=True)
    print("Saved (%s,%s,%s,%s, %s)" % (old_exam.id, old_exam.title, old_exam.examiners, old_exam.date, old_exam.old_folder_id))

  print("Converted %d/%d exams" % (convertedExams, Inhalt.select().count()))

def convertCurrentLendOuts():
  convertedLendOuts = 0
  for ausleihe in Ausleihe.select().where(Ausleihe.datumRein >> None):
    print("convertCurrentLendOuts - Ausleihe %d" % ausleihe.ausleihID)
    lendout = AusleiheToLendOut(ausleihe)
    convertedLendOuts += lendout.save(force_insert=True)
    print("Saved (%s, %s, %s)" % (lendout.id, lendout.receiver, lendout.receivingTime))
    ais = Ausleihe_Ordner.select().where(Ausleihe_Ordner.ausleihID == lendout.id)
    print("Found %s ais" % ais.count())
    for ai in ais:
      barcodeId = "%03d%d" % (ai.ordnerID, ai.ordnerNummer)
      instances = Old_Folder_Instances.select().where(Old_Folder_Instances.barcodeId == barcodeId)
      print("Found %d related instances for %s" % (instances.count(),barcodeId))
      for instance in instances:
        instance.old_lend_out_id = lendout.id
        instance.save()
        print("Updated %d to be lent in %d" % (instance.id, instance.old_lend_out_id))
  return convertedLendOuts


def convertLendOutHistory():
  convertedLendOuts = 0
  for ausleihe in Ausleihe.select().where(~(Ausleihe.datumRein >> None)):
    print("Starting conversion of hist. Ausleihe %d" % ausleihe.ausleihID)
    lendout = AusleiheToLendOut(ausleihe)
    convertedLendOuts += lendout.save(force_insert=True)
    print("Saved (%s, %s, %s)" % (lendout.id, lendout.receiver, lendout.receivingTime))
    ais = Ausleihe_Ordner.select().where(Ausleihe_Ordner.ausleihID == lendout.id)
    print("Found %s ais" % ais.count())
    for ai in ais:
      barcodeId = "%03d%d" % (ai.ordnerID, ai.ordnerNummer)
      instances = Old_Folder_Instances.select().where(Old_Folder_Instances.barcodeId == barcodeId)
      print("Found %d related history instances for %s" % (instances.count(),barcodeId))
      for instance in instances:
        history_entry = Archived_Old_Lend_Outs_Old_Folder_Instances()
        history_entry.archived_old_lend_out_id = lendout.id
        history_entry.old_folder_instance_id = instance.id
        history_entry.save(force_insert=True)
        print("Created history_entry (%d, %d)" % (lendout.id, instance.id))
  return convertedLendOuts


def convertLendOuts():
  convertedLendOuts = 0
  convertedLendOuts += convertCurrentLendOuts()
  convertedLendOuts += convertLendOutHistory()
  
  print("Converted %d/%d lendouts" % (convertedLendOuts, Ausleihe.select().count()))


#
# Conversion starts here
#
defaultFolder = createDefaultFolder()
convertFolders()
convertExams(defaultFolder)
convertLendOuts()