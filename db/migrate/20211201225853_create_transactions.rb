class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.float :amount, null: false
      t.string :currency, null: false, index: true
      t.string :transaction_type, null: false, index: true
      t.boolean :transfer, null: false, index: true, default: false
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
