class OldFolderInstance < ActiveRecord::Base
  belongs_to :folder

  validates: number,    presence: true, :inclusion => {:in => 1..9}
  validates: folder_id, presence: true
end
