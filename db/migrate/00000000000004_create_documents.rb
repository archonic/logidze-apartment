class CreateDocuments < ActiveRecord::Migration[5.2]
  require 'logidze/migration'
  include Logidze::Migration

  def up
    create_table :documents, force: true do |t|
      t.string :name, null: false
      t.references :account
      t.string :body, null: false
      t.jsonb :log_data
      t.timestamps
    end
    Document.reset_column_information
    execute <<-SQL
      CREATE TRIGGER logidze_on_documents
      BEFORE UPDATE OR INSERT ON documents FOR EACH ROW
      WHEN (coalesce(#{current_setting('logidze.disabled')}, '') <> 'on')
      EXECUTE PROCEDURE logidze_logger(null, 'updated_at', '{id, account_id, created_at, updated_at}');
    SQL
  end

  def down
    execute "DROP TRIGGER IF EXISTS logidze_on_documents on documents;"
    drop_table :documents
  end
end
