FactoryBot.define do
  factory :valid_query, class: Query do
    query "select * from queries limit 1;"
    results []
  end

  factory :invalid_query, class: Query do
    query "drop table eviction_notices;"
    results []
  end
end
