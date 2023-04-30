class Payroll < ApplicationRecord
  belongs_to :period
  belongs_to :worker
  has_many :payroll_additions, dependent: :destroy
  has_one :company, through: :period
  has_many :wages, through: :period

  validates_uniqueness_of :worker_id, scope: :period_id
  validates :worker_payment, numericality: { greater_than: 0 }, if: :worker_valid_for_period?

  validate :validate_worker_valid_for_period

  def recalculate!
    result = PayrollUpdater.call(self)
    result[:payroll] || false
  end

  def validate_worker_valid_for_period
    return if worker_valid_for_period?

    errors.add(:worker_id, :not_valid_for_period)
  end

  def worker_valid_for_period?
    worker.valid_for_period?(period)
  end
end
