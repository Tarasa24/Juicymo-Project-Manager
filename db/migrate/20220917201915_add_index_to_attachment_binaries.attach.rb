# frozen_string_literal: true

# This migration comes from attach (originally 20181123160000)
class AddIndexToAttachmentBinaries < ActiveRecord::Migration[7.0]
  def up
    add_index :attachment_binaries, :attachment_id
  end

  def down
    remove_index :attachment_binaries, :attachment_id
  end
end
