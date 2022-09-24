# frozen_string_literal: true

module CommonScopes
  extend ActiveSupport::Concern

  included do
    # Searches for a given query, defined by their title (case-insensitive)
    # @param query [String] The query
    # @example
    # Task.search("My task")
    # # => #<ActiveRecord::Relation [#<Task id: 1, title: "My task", ...>]>
    # Project.search("My project")
    # # => #<ActiveRecord::Relation [#<Project id: 1, title: "My project", ...>]>
    scope :search, -> (query) { where("lower(title) LIKE ?", "%#{query.downcase}%") }
  end
end
