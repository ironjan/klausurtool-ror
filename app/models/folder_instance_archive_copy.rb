# Represents a copy of a folder instance for the archive. This decouples the 
# archive from the rest of the system, i.e. missing folder instances can be 
# deleted without impacting the archive.
class FolderInstanceArchiveCopy < ApplicationRecord
  belongs_to :archived_old_lend_out
end
