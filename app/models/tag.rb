class Tag < ApplicationRecord
  # Validations
  validates :title, presence: true

  # Associations
  has_many :tags_tasks, class_name: 'TagsTasks', dependent: :delete_all
  has_many :tasks, through: :tags_tasks
  belongs_to :user

  def self.get_tags_for_tasks_in_project(project)
    Tag.left_joins(:tasks).where(tasks: { project_id: project.id })
  end

  def self.search(query)
    Tag.where('lower(title) LIKE ?', "%#{query.downcase}%")
  end
end
