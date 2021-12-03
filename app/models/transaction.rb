class Transaction < ApplicationRecord
  belongs_to :client

  TRANSACTION_TYPES = ['UP', 'DOWN']

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :currency, presence: true, case_sensitive: false, currency: true
  validates :transfer, inclusion: { in: [true, false] }
  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPES }
  validates :client_id, presence: true
end
