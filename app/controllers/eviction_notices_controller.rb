class EvictionNoticesController < ApplicationController
  def index
    if params[:query_id]
      query = Query.find(params[:query_id])
      query_results = query.results
      @evictions = EvictionNotice.where(eviction_id: query_results)
    else
      @evictions = EvictionNotice.limit(10)
    end
  end

  def run_query
    # fix this!!! sql injection!!! need to sanitize!!!
    results = ActiveRecord::Base.connection.exec_query(query_params)
    row_ids = results.rows.map(&:first)
    evictions = EvictionNotice.where(eviction_id: row_ids)

    new_query = Query.new(query: query_params, results: row_ids)
    if new_query.save!
      redirect_to eviction_notices_path(query_id: new_query.id)
    else
      render :index, notice: 'Query could not be executed!'
    end
  end

  private

  def query_params
    params[:query]
  end
end
