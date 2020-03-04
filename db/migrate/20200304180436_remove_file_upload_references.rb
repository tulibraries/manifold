# frozen_string_literal: true

class RemoveFileUploadReferences < ActiveRecord::Migration[5.2]
  def change
    remove_reference :file_uploads, :attachable, index: true
  end
end
