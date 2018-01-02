class QueriesController < ApplicationController
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
