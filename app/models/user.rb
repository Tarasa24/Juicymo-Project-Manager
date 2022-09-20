# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  # Validations
  validates :first_name, presence: true
  validates :second_name, presence: true

  # Associations
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :tags, dependent: :destroy

  # Methods

  # Returns the full name of the user
  # @return [String] the full name of the user
  # @example
  #  user.full_name
  # => "John Doe"
  def full_name
    "#{first_name} #{second_name}"
  end
end
