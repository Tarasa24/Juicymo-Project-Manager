module SearchHelper
  # Returns url of search results depending on its type
  # @param [Hash] result
  # @return [String]
  # @example
  #  search_result_url(result) #=> "/projects/1"
  #  search_result_url(result) #=> "/projects/1/tasks/1"
  #  search_result_url(result) #=> "/tags?query=title"
  def link(result)
    if result['type'] == 'Project'
      project_path(result['id'])
    elsif result['type'] == 'Task'
      project_task_path(result['project_id'], result['id'])
    elsif result['type'] == 'Tag'
      tags_path(query: result['title'])
    end
  end
end
