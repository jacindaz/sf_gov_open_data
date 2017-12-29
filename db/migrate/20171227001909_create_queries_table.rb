class CreateQueriesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :queries do |t|
      t.string :query, null: false
      t.string :results, array: true, default: []

      t.timestamps
    end
  end
end
