class Equipment < ApplicationRecord
  belongs_to :category
  has_many :maintenance_records, dependent: :destroy

  validates :name, presence: true
  validates :serial_number, presence: true, uniqueness: { case_sensitive: false }
  validates :status, presence: true, inclusion: { in: %w[available in_use maintenance] }
end
