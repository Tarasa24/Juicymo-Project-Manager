class Task < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :is_done, inclusion: { in: [true, false] }, presence: true
end
