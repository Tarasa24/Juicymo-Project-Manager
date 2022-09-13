class Project < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :position, presence: true

  # Associations
  has_many :tasks, dependent: :destroy
  belongs_to :user, foreign_key: true
end
