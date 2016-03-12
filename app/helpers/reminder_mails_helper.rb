module ReminderMailsHelper
  include ImtToNameHelper

  def recipient(old_lend_out)
    "#{old_lend_out.imt}@mail.upb.de"
  end

  def subject
    "[Klausurausleihe] Verliehene Ordner/Mappen zeitnah zurückbringen"
  end

  def cc
    "fsmi@upb.de; fsmi-klausurarchiv@lists.upb.de"
  end

  def body(old_lend_out)
    name = name_for_login(old_lend_out.imt)

    folder_list = old_lend_out.old_folder_instances
                      .map { |i| i.old_folder.title }
                      .join("\n")

    "Hallo #{name},\n"\
    "\n"\
    "bitte bringe die von dir ausgeliehenen Ordner baldmöglichst zurück:\n"\
    "\n"\
    "#{folder_list}\n"\
    "\n"\
    "Viele Grüße,\n"\
    "<Name>\n"\
    "Fachschaft Mathematik/Informatik"
  end
end
