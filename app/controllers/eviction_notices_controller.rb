class EvictionNoticesController < ApplicationController
  def index
    @evictions = paginate_evictions(EvictionNotice.order(:state))
    @query = Query.new
  end

  def show
    @query = Query.find(params[:id])
    query_results = @query.results
    @evictions = paginate_evictions(EvictionNotice.where(eviction_id: query_results))

    render :index, collection: @evictions
  end

  def run_query
    @query = Query.new(query: query_params, results: [])

    begin
      results = ActiveRecord::Base.connection.exec_query(query_params)
    rescue ActiveRecord::StatementInvalid
      results = nil
      flash[:notice] = "Query syntax is invalid."
    end

    if !valid_query
      flash[:notice] = "#{Query::INVALID_SQL.join(', ')} statements cannot be run."
      @evictions = EvictionNotice.none

      render :index, collection: @evictions
    elsif results.nil?
      @evictions = EvictionNotice.none

      render :index, collection: @evictions
    else
      row_ids = results.rows.map(&:first)
      @evictions = paginate_evictions(EvictionNotice.where(eviction_id: row_ids))

      render :index, collection: @evictions
    end
  end

  private

  def paginate_evictions(evictions)
    evictions.page(params[:page]).without_count
  end

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

  def valid_query
    # hmm, should i sanitize by not allowing drop/delete
    # or sanitize by only allowing selects/with/etc ??
    Query::INVALID_SQL.none?{ |invalid| query_params.include?(invalid) }
  end
end
