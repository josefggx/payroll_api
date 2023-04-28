class Payroll < ApplicationRecord
  belongs_to :period
  belongs_to :worker
  has_many :payroll_additions
  has_one :company, through: :period

  validates_uniqueness_of :worker_id, scope: :period_id
  validates :worker_payment, numericality: { greater_than: 0 }

  validate :worker_valid_for_period

  def worker_valid_for_period
    if worker.wages
             .where("(wages.initial_date <= ? AND wages.end_date >= ?) OR (wages.initial_date BETWEEN ? AND ?) OR
                    (wages.end_date BETWEEN ? AND ?)", period.end_date, period.start_date, period.start_date,
                    period.end_date, period.start_date, period.end_date).empty?

      errors.add(:worker_id, "has no wages within the period's start and end dates")
    end
  end
end
