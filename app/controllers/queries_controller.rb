class QueriesController < ApplicationController
  def index
    @queries = Query.all
    @new_query = Query.new
  end

  def show
  end

  def create
    @saved_query = Query.new(query_params)

    if !valid_query(query_params[:query])
      flash[:notice] = "#{Query::INVALID_SQL.join(', ')} statements cannot be saved."
      @new_query = Query.new
      @queries = Query.all
      render :index
    else
      begin
        results = ActiveRecord::Base.connection.exec_query(query_params[:query])
      rescue Exception => e
        flash[:notice] = e.message
        @new_query = Query.new(query_params)
        @queries = Query.all
        render :index
      else
        if @saved_query.save!
          redirect_to query_path(@saved_query)
        else
          @new_query = Query.new(query_params)
          render :index, notice: "Query could not be saved!"
        end
      end
    end
  end

  def run_query
    if params[:commit] == "Run query"
      @running_query = Query.new(query_params)
    elsif params[:commit] == "persisted_query"
      @running_query = Query.find(params[:query][:id])
    end

    if !valid_query(@running_query.query)
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

  def valid_query(query)
    Query::INVALID_SQL.none?{ |invalid| query.include?(invalid) }
  end

  def clean_up_query
    # remove \t and \n
  end
end
