class QueriesController < ApplicationController
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
      redirect_to queries_path
    else
      render :index, notice: "Query could not be executed!"
    end
  end

  def run_query
    if params[:commit] == "Run query"
      @running_query = Query.new(query_params)
    elsif params[:commit] == "persisted_query"
      @running_query = Query.find(params[:query][:id])
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

  def query_params
    params.require(:query).permit(:query)
  end

  def valid_query
    # hmm, should i sanitize by not allowing drop/delete
    # or sanitize by only allowing selects/with/etc ??
    Query::INVALID_SQL.none?{ |invalid| query_params.include?(invalid) }
  end
end
