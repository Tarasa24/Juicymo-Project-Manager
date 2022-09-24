class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    project_search = Project.select(:id, :title, "'Project' as type", "null as project_id")
                            .search(params[:query]).where(user: current_user)
    task_search = Task.select(:id, :title, "'Task' as type", :project_id)
                      .search(params[:query]).where(user: current_user)
    tag_search = Tag.select(:id, :title, "'Tag' as type", "null as project_id")
                    .search(params[:query]).where(user: current_user)
    sql = "#{project_search.to_sql} UNION #{task_search.to_sql} UNION #{tag_search.to_sql}"
    @results = ActiveRecord::Base.connection.execute(sql)
    @query = params[:query]
  end
end
