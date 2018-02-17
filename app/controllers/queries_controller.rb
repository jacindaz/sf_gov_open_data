class QueriesController < ApplicationController
  # MIGRATION PLAN
  # => move 1 action at a time
  # => tests!!! run for each change
  # => make controller/view work for only eviction notices
  # => then make controller/view work for all tables
  # => then fix rendering to be more flexible for query results

  def index
    @queries = Query.all
    @new_query = Query.new
  end

  def create
    results = ActiveRecord::Base.connection.exec_query(query_params)
    row_ids = results.rows.map(&:first)

    new_query = Query.new(query: query_params, results: row_ids)
    if new_query.save!
      redirect_to eviction_notice_path(new_query)
    else
      render "eviction_notices/index", notice: "Query could not be executed!"
    end
  end

  private

  def query_params
    params[:query]
  end
end
