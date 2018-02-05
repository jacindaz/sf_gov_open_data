require "elasticsearch/persistence"

desc "Push data to elasticsearch"
task push_to_elasticsearch: :environment do
  EvictionNotice.__elasticsearch__.create_index! force: true

  EvictionNotice.import do |response|
    puts "Processed #{response['items'].length}, with " \
            + response["items"].select { |i| i["index"]["error"] }.size.to_s \
            + " errors"
  end
end
