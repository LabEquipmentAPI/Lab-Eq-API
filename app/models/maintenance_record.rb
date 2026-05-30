class MaintenanceRecord < ApplicationRecord
  belongs_to :equipment

  validates :description, presence: true
  validates :performed_at, presence: true

  validates :date_cannot_be_in_the_future

  private
  def date_cannot_be_in_the_future
    if performed_at.present? && performed_at > Time.current
      errors.add(:performed_at, "can't be in the future")
    end
  end
end
