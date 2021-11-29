class Client < ApplicationRecord
  has_and_belongs_to_many :tags
  has_many :bank_account_numbers

  validates :name, presence: true
  validates :surname, presence: true
  validates :patronymic, presence: true
  validates :identification_number, presence: true, uniqueness: true, case_sensitive: false
  validate :valid_identification_number

  before_save :format_data

  private

  def format_data
    self.name = self.name.upcase
    self.surname = self.surname.upcase
    self.patronymic = self.patronymic.upcase
    self.identification_number = self.identification_number.upcase
  end

  def valid_identification_number
    valid_size = identification_number.size == 14
    valid_structure_id = identification_number =~ %r{\d{7}\S\d{3}\S{2}\d{1}}
    errors.add(:identification_number, "incorrect identification_number") unless valid_size && valid_structure_id
  end

end
