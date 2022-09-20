# frozen_string_literal: true

class AddUserToTag < ActiveRecord::Migration[7.0]
  def change
    add_reference :tags, :user, null: false, foreign_key: true
  end
end
