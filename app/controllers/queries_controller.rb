class QueriesController < ApplicationController
  protect_from_forgery except: :index

  def index
    @queries = Query.all
    @new_query = Query.new
  end

  def show
    @running_query = Query.find(params[:id])
    @results = @running_query.execute_query
    @new_query = Query.new
  end

  def create
    @query_to_save = Query.new(query_params)

    if @query_to_save.query_contains_ddl
      invalid_query_error_instance_vars("#{Query::INVALID_SQL.join(', ')} statements cannot be saved.")
    else
      begin
        ActiveRecord::Base.connection.exec_query(query_params[:query])
      rescue Exception => e
        ActiveRecord::Base.connection.execute "ROLLBACK"
        invalid_query_error_instance_vars(e.message)
      else
        if @query_to_save.save!
          redirect_to query_path(@query_to_save)
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
    else
      @running_query = Query.find(params[:query][:id])
    end

    if @running_query.query_contains_ddl
      invalid_query_error_instance_vars("#{Query::INVALID_SQL.join(', ')} statements cannot be run.")
    else
      begin
        results = ActiveRecord::Base.connection.exec_query(@running_query.query)
      rescue Exception => e
        ActiveRecord::Base.connection.execute "ROLLBACK"
        invalid_query_error_instance_vars(e.message)
      else
        @new_query = Query.new
        @results = results
        render :show
      end
    end
  end

  private

  def query_params
    params.require(:query).permit(:query)
  end

  def invalid_query_error_instance_vars(error_message)
    flash[:notice] = error_message
    @new_query = Query.new(query_params)
    @queries = Query.all
    render :index
  end

  def clean_up_query
    # remove \t and \n
  end
end
