require 'rails_helper'

RSpec.describe "EvictionNotices", type: :request do
  describe "GET /eviction_notices" do
    it "works! (now write some real specs)" do
      get eviction_notices_path
      expect(response).to have_http_status(200)
    end
  end
end
