require 'net/http'
require 'json'

class ImportSFPoliceData
  attr_reader :json_response

  def initialize
    uri = URI('https://data.sfgov.org/resource/cuks-n6tp.json')
    response = Net::HTTP.get(uri)
    @json_response = JSON.parse(response)
  end
end
