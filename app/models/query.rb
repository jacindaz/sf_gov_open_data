class Query < ApplicationRecord
  INVALID_SQL = ["alter", "drop", "delete"]

  def execute_query
    if query_contains_ddl
      invalid_query_error_instance_vars("DDL statements such as #{Query::INVALID_SQL.join(', ')} cannot be executed.")
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

  def query_contains_ddl
    INVALID_SQL.any?{ |invalid| query.include?(invalid) }
  end
end
