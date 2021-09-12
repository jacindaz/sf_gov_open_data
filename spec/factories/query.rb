FactoryBot.define do
  factory :valid_query, class: Query do
    query { "select * from queries limit 1;" }
    results { [] }
  end

  factory :query_with_dml, class: Query do
    query { "drop table eviction_notices;" }
    results { [] }
  end

  factory :invalid_query, class: Query do
    query { "select id from non_existant_table limit 1;" }
    results { [] }
  end
end
