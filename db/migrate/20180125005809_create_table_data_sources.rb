class CreateTableDataSources < ActiveRecord::Migration[5.1]
  def change
    create_table :data_sources do |t|
      t.string :title, null: false
      t.string :data_sf_uuid, null: false
      t.string :url, null: false

      t.string :table_name

      t.date :date_downloaded, null: false
      t.date :data_freshness_date, null: false

      t.text :description

      t.timestamps
    end
  end
end
