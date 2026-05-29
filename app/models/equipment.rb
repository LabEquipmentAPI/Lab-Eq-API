class Equipment < ApplicationRecord
  belongs_to :category
  has_many :maintenance_records, dependent: :destroy

  validates :name, presence: true
  validates :serial_number, presence: true, uniqueness: { case_sensitive: false }
  validates :status, presence: true, inclusion: { in: %w[available in_use maintenance] }

  validates :serial_number, format: { 
    with: /\A[A-Z]{3}-\d{3}\z/, 
    message: "must match format XXX-NNN (three uppercase letters, a dash, three digits)" 
  }
  
  validate :name_must_be_real 

  private

  def name_must_be_real
    if name.present? && (name.length < 3 || !name.match?(/[a-zA-Z]/))
      errors.add(:name, "must be at least 3 characters and must contain at least one letter")
    end
  end
end
