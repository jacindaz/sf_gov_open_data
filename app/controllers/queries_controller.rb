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
      @queries = Query.all
      @new_query = Query.new(query: params[:query][:query])

      render :index
    else
      begin
        results = ActiveRecord::Base.connection.exec_query(@running_query.query)
      rescue Exception => e
        flash[:notice] = e.message
        @queries = Query.all
        @new_query = Query.new(query: params[:query][:query])

        render :index
      else
        @new_query = Query.new
        @results = results
        render :show
      end
    end
  end

  def query_params
    params.require(:query).permit(:query)
  end

  def valid_query
    Query::INVALID_SQL.none?{ |invalid| query_params["query"].include?(invalid) }
  end

  def clean_up_query
    # remove \t and \n
  end
end
