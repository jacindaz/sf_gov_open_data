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
      happy_path_query = create :valid_query

      post run_query_path(query: happy_path_query.attributes, commit: "persisted_query")
      expect(response).to have_http_status(200)
    end

    it "successfully runs valid un-persisted query, no DML in SQL" do
      happy_path_query = build :valid_query

      post run_query_path(query: happy_path_query.attributes, commit: "Run query")
      expect(response).to have_http_status(200)
    end

    it "returns an error when persisted query contains DML commands" do
      query_contains_dml = create :query_with_dml
      post run_query_path(query: query_contains_dml.attributes, commit: "persisted_query")

      expect(response).to have_http_status(200)
      expect(response.body).to include("cannot be run")
    end

    it "returns an error when un-persisted query contains DML commands" do
      query_contains_dml = build :query_with_dml
      post run_query_path(query: query_contains_dml.attributes, commit: "Run query")

      expect(response).to have_http_status(200)
      expect(response.body).to include("cannot be run")
    end

    it "returns an error when persisted query contains error" do
      invalid_sql = create :invalid_query
      post run_query_path(query: invalid_sql.attributes, commit: "persisted_query")

      expect(response).to have_http_status(200)
      expect(response.body).to include("PG::UndefinedTable: ERROR")
    end

    it "returns an error when un-persisted query contains errory" do
      invalid_sql = build :invalid_query
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

    it "should not save + return an error for queries with DML commands" do
      query_with_dml = build :query_with_dml
      post queries_path(query: query_with_dml.attributes)

      expect(response).to have_http_status(200)
      expect(response.body).to include("cannot be saved")
    end

    it "should not save + return an error for invalid queries" do
      invalid_query = build :invalid_query
      post queries_path(query: invalid_query.attributes)

      expect(response).to have_http_status(200)
      expect(response.body).to include("PG::UndefinedTable: ERROR")
    end
  end

  describe "GET#show" do
    it "should successfully display saved queries" do
      happy_path_query = create :valid_query

      get query_path(happy_path_query)
      expect(response).to have_http_status(200)
    end
  end
end
