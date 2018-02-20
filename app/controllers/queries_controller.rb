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

  def show
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

  def run_query
    if params[:query]
      @running_query = Query.find(params[:query])
    else
      @running_query = Query.new(query: query_params, results: [])
    end

    begin
      results = ActiveRecord::Base.connection.exec_query(@running_query.query)
    rescue ActiveRecord::StatementInvalid
      results = nil
      flash[:notice] = "Query syntax is invalid."
    end

    if !valid_query
      flash[:notice] = "#{Query::INVALID_SQL.join(', ')} statements cannot be run."
      @queries = []
      render :index
    elsif results.nil?
      @queries = []
      render :index
    else
      @results = results
      render :show
    end
  end

  private

  def query_params
    params[:query]
  end

  def valid_query
    # hmm, should i sanitize by not allowing drop/delete
    # or sanitize by only allowing selects/with/etc ??
    Query::INVALID_SQL.none?{ |invalid| query_params.include?(invalid) }
  end
end
