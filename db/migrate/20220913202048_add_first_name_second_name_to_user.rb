# frozen_string_literal: true

class AddFirstNameSecondNameToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string, null: false, default: ""
    add_column :users, :second_name, :string, null: false, default: ""
  end
end
