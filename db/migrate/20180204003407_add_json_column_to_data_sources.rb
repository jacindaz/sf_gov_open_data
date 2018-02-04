class AddJsonColumnToDataSources < ActiveRecord::Migration[5.1]
  def change
    add_column :data_sources, :json_endpoint, :string
  end
end
