class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.float :balance, null: false, default: 0.0
      t.string :account_number, null: false, unique: true
      t.string :currency, null: false
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
    add_index :accounts, [:client_id, :currency]
  end
end
