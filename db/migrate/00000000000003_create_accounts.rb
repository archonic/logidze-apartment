class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts, force: true do |t|
      t.string :name, null: false
      t.string :subdomain, null: false
      t.timestamps
    end
  end
end
