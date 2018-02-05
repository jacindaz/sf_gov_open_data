require "elasticsearch/persistence"

desc "Push data to elasticsearch"
task push_to_elasticsearch: :environment do
  EvictionNotice.__elasticsearch__.create_index! force: true
  index_name = EvictionNotice.__elasticsearch__.index_name

  puts "\n=============================="
  puts "Created index: #{index_name}"
  puts "==============================\n"

  total_processed = 0
  EvictionNotice.import do |response|
    batch = response["items"].length.to_i
    total_processed += batch

    puts "Processed #{total_processed}, with " \
            + response["items"].select { |i| i["index"]["error"] }.size.to_s \
            + " errors"
  end

  EvictionNotice.__elasticsearch__.refresh_index!
  num_documents = EvictionNotice.__elasticsearch__.client.search(index: index_name)["hits"]["total"]

  puts "\n=============================="
  puts "Inserted #{num_documents} documents into index #{index_name}"
  puts "==============================\n"
end
