class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
