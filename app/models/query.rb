class Query < ApplicationRecord
  INVALID_SQL = ["drop", "delete"]

  def execute_query
    if query_contains_dml
      invalid_query_error_instance_vars("#{Query::INVALID_SQL.join(', ')} statements cannot be executed.")
    else
      begin
        results = ActiveRecord::Base.connection.exec_query(query)
      rescue Exception => e
        ActiveRecord::Base.connection.execute "ROLLBACK"
        invalid_query_error_instance_vars(e.message)
      end
    end

    results
  end

  def query_contains_dml
    INVALID_SQL.any?{ |invalid| query.include?(invalid) }
  end
end
