require "rails_helper"

RSpec.describe "EvictionNotices", type: :request do
  describe "GET /eviction_notices" do
    it "renders successfully!" do
      get eviction_notices_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET#show" do
    it "renders successfully!" do
      get eviction_notice_path(create :valid_query)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET#run_query" do
    it "successfully runs a query with valid sql" do
      valid_query = create :valid_query
      post run_query_eviction_notices_path(query: valid_query.query)
      expect(response).to have_http_status(200)
    end

    it "returns an error when sql is invalid" do
      invalid_query = create :invalid_query
      post run_query_eviction_notices_path(query: invalid_query.query)

      expect(response).to have_http_status(200)
      expect(response.body).to include("cannot be run")
    end
  end
end
