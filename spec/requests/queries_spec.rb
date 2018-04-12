require "rails_helper"

RSpec.describe "Queries", type: :request do
  describe "GET /queries" do
    it "renders successfully!" do
      get queries_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET#run_query" do
    it "successfully runs a valid persisted query, no DML in SQL" do
      valid_query = create :valid_query

      post run_query_path(query: valid_query.attributes, commit: "persisted_query")
      expect(response).to have_http_status(200)
    end

    it "successfully runs valid un-persisted query, no DML in SQL" do
      valid_query = build :valid_query

      post run_query_path(query: valid_query.attributes, commit: "Run query")
      expect(response).to have_http_status(200)
    end

    it "returns an error when persisted query contains DML commands" do
      invalid_query = create :invalid_query
      post run_query_path(query: invalid_query.attributes, commit: "persisted_query")

      expect(response).to have_http_status(200)
      expect(response.body).to include("cannot be run")
    end

    it "returns an error when un-persisted query contains DML commands" do
      invalid_query = build :invalid_query
      post run_query_path(query: invalid_query.attributes, commit: "Run query")

      expect(response).to have_http_status(200)
      expect(response.body).to include("cannot be run")
    end

    it "returns an error when persisted query contains error" do
      invalid_sql = create :invalid_query, query: "select id from nonexistant_table limit 2;"
      post run_query_path(query: invalid_sql.attributes, commit: "persisted_query")

      expect(response).to have_http_status(200)
      expect(response.body).to include("PG::UndefinedTable: ERROR")
    end

    it "returns an error when un-persisted query contains errory" do
      invalid_sql = build :invalid_query, query: "select id from nonexistant_table limit 2;"
      post run_query_path(query: invalid_sql.attributes, commit: "Run query")

      expect(response).to have_http_status(200)
      expect(response.body).to include("PG::UndefinedTable: ERROR")
    end
  end

  describe "POST#create" do
    it "should save queries successfully" do
      valid_query = build :valid_query
      post queries_path(query: valid_query.attributes)

      saved_query = Query.find_by_query(valid_query.query)
      expect(response).to redirect_to(query_path(saved_query))
    end
  end
end
