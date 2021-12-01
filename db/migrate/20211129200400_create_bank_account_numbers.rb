class CreateBankAccountNumbers < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_account_numbers do |t|
      t.float :balance, null: false, default: 0.0
      t.string :currency, null: false, index: true
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
