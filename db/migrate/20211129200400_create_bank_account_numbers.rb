class CreateBankAccountNumbers < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_account_numbers do |t|
      t.integer :account_number, index: { unique: true }, null: false
      t.float :balance, null: false
      t.string :currency_type, null: false
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
