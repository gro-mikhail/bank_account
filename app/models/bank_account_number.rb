class BankAccountNumber < ApplicationRecord
  belongs_to :client

  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :currency, presence: true, case_sensitive: false, currency: true
  validates :client_id, presence: true, uniqueness: { scope: :currency, message: "An account in this currency exists" }
end
