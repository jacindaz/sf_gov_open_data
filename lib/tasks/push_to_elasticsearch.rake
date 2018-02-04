require 'elasticsearch/persistence'

desc "Push data to elasticsearch"
task :push_to_elasticsearch => :environment do
  connection = PG.connect(dbname: "sf_gov_open_data_dev")
  repository = Elasticsearch::Persistence::Repository.new

  EvictionNotice.take(10).each do |eviction_notice|
    repository.save(eviction_notice)
  end
end
