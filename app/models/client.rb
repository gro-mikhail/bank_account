class Client < ApplicationRecord
  has_and_belongs_to_many :tags
  has_many :bank_account_numbers

  validates :name, presence: true
  validates :surname, presence: true
  validates :patronymic, presence: true
  validates :identification_number, presence: true, uniqueness: true, case_sensitive: false,
            format: { with: /\d{7}[A-Z]{1}\d{3}[A-Z]{2}\d{1}/,  message: "invalid id format" },
            length: { is: 14,  message: "length must be 14 characters"}
end
