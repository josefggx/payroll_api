# == Schema Information
#
# Table name: payrolls
#
#  id                       :uuid             not null, primary key
#  period_id                :uuid             not null
#  worker_id                :uuid             not null
#  base_salary              :decimal(15, 2)   not null
#  transport_subsidy        :decimal(15, 2)   not null
#  additional_salary_income :decimal(15, 2)   not null
#  non_salary_income        :decimal(15, 2)   not null
#  worker_healthcare        :decimal(15, 2)   not null
#  worker_pension           :decimal(15, 2)   not null
#  solidarity_fund          :decimal(15, 2)   not null
#  subsistence_account      :decimal(15, 2)   not null
#  deductions               :decimal(15, 2)   not null
#  company_healthcare       :decimal(15, 2)   not null
#  company_pension          :decimal(15, 2)   not null
#  arl                      :decimal(15, 2)   not null
#  compensation_fund        :decimal(15, 2)   not null
#  icbf                     :decimal(15, 2)   not null
#  sena                     :decimal(15, 2)   not null
#  severance                :decimal(15, 2)   not null
#  interest                 :decimal(15, 2)   not null
#  premium                  :decimal(15, 2)   not null
#  vacation                 :decimal(15, 2)   not null
#  worker_payment           :decimal(15, 2)   not null
#  total_company_cost       :decimal(15, 2)   not null
#
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
