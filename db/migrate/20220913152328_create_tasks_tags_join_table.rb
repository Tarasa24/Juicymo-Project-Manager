# frozen_string_literal: true

class CreateTasksTagsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :tasks, :tags,
                      column_options: { null: false, foreign_key: true } do |t|
      t.index [:task_id, :tag_id]
      t.index [:tag_id, :task_id]
    end
  end
end
