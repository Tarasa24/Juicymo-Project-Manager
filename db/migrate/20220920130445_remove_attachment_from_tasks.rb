class RemoveAttachmentFromTasks < ActiveRecord::Migration[7.0]
  def change
    remove_column :tasks, :attachment, :string
  end
end
