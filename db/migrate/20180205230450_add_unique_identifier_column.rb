class AddUniqueIdentifierColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :data_sources, :unique_identifier_column_name, :string
  end
end
