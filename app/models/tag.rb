class Tag < ApplicationRecord
  has_and_belongs_to_many :clients

  validates :name, presence: true, uniqueness: true, case_sensitive: false
end
