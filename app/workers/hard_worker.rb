require 'sidekiq/api'
require 'pry'

class HardWorker
  include Sidekiq::Worker

  def perform(pol_incidents_hash)
    pol_incidents_hash.each do |pi|
      PoliceIncident.find_or_create_by!(pi)
    end
  end
end
