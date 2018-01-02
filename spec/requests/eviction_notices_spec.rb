require 'rails_helper'

RSpec.describe "EvictionNotices", type: :request do
  describe "GET /eviction_notices" do
    it "works! (now write some real specs)" do
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
    end

    it "returns an error when sql is invalid" do
    end
  end
end
