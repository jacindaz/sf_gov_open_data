class EvictionNoticesController < ApplicationController
  def index
    @evictions = EvictionNotice.limit(10)
  end
end
