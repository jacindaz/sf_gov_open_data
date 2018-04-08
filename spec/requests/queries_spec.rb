require "rails_helper"

RSpec.describe "Queries", type: :request do
  describe "GET /queries" do
    it "renders successfully!" do
      get queries_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET#run_query" do
    it "successfully runs a query with valid sql for persisted query" do
      valid_query = create :valid_query

      post run_query_path(query: valid_query.attributes, commit: "persisted_query")
      expect(response).to have_http_status(200)
    end

    it "successfully runs a query with valid sql for an un-persisted query" do
      valid_query = build :valid_query

      post run_query_path(query: valid_query.attributes, commit: "Run query")
      expect(response).to have_http_status(200)
    end

    it "returns an error when sql is invalid" do
      invalid_query = create :invalid_query
      post run_query_path(query: invalid_query.attributes)

      expect(response).to have_http_status(200)
      expect(response.body).to include("cannot be run")
    end
  end

  describe "POST#create" do
    it "should save queries successfully" do
      valid_query = build :valid_query
      post queries_path(query: valid_query.attributes)

      expect(response).to redirect_to(queries_path)
    end
  end
end
