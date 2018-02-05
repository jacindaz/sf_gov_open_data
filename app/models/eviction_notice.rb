require "elasticsearch/model"

class EvictionNotice < ApplicationRecord
  include Elasticsearch::Model
end
