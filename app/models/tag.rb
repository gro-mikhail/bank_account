class Tag < ApplicationRecord
  has_and_belongs_to_many :clients

  validates :name, presence: true, uniqueness: true, case_sensitive: false

  before_save :format_data

  private

  def format_data
    self.name = self.name.upcase
  end
end
