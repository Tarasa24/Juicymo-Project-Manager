class Project < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :position, presence: true

  # Associations
  has_many :tasks, dependent: :destroy
  belongs_to :user, foreign_key: true

  # Methods
  def self.get_dashboard(user_id)
    bare_projects = Project.select(:id, :position, :title, :updated_at).where(user_id: user_id).order(:position)
    tasks = Task.select(
                  :project_id,
                  'COUNT(id) AS total_tasks',
                  'SUM(CASE WHEN is_done THEN 1 ELSE 0 END) AS completed_tasks')
                .where(user_id: user_id).group(:project_id)
    bare_projects.map do |project|
      project.attributes.merge(tasks[project.id].first.attributes)
    end
  end
end
