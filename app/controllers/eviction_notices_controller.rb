class EvictionNoticesController < ApplicationController
  def index
    @evictions = EvictionNotice.limit(10)
  end

  def show
    query = Query.find(params[:id])
    query_results = query.results
    @evictions = EvictionNotice.where(eviction_id: query_results)

    render :index
  end

  def run_query
    # fix this!!! sql injection!!! need to sanitize!!!
    results = ActiveRecord::Base.connection.exec_query(query_params)
    row_ids = results.rows.map(&:first)
    @evictions = EvictionNotice.where(eviction_id: row_ids)

    render :index, collection: @evictions
  end

  private

  def query_params
    params[:query]
  end

  def save_query
    new_query = Query.new(query: query_params, results: row_ids)
    if new_query.save!
      render :index, collection: @evictions
      redirect_to eviction_notice_path(query_id: new_query.id)
    else
      render :index, notice: "Query could not be executed!"
    end
  end
end
