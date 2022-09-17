class Task < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :is_done, inclusion: { in: [true, false] }

  # Attachments
  attachment :file

  # Associations
  belongs_to :project
  belongs_to :user

  has_many :tags_tasks, class_name: 'TagsTasks', dependent: :delete_all
  has_many :tags, through: :tags_tasks

  # Methods
  def self.search(query)
    Task.where("lower(title) LIKE ?", "%#{query.downcase}%")
  end
end
