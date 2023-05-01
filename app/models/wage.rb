# == Schema Information
#
# Table name: wages
#
#  id                :uuid             not null, primary key
#  base_salary       :decimal(15, 2)   not null
#  transport_subsidy :boolean          not null
#  initial_date      :date             not null
#  end_date          :date
#  contract_id       :uuid             not null
#
class Wage < ApplicationRecord
  include PayrollHelper

  belongs_to :contract
  has_one :company, through: :contract
  has_one :worker, through: :contract
  has_many :periods, through: :worker
  has_many :payrolls, through: :periods

  validates :base_salary, presence: true, numericality: { greater_than: 0, if: -> { base_salary.present? } }
  validates :transport_subsidy, inclusion: { in: [true, false], if: -> { transport_subsidy.present? } }
  validates :initial_date, presence: true, date: true

  validate :initial_date_in_contract_dates
  validate :initial_date_greater_than_last, if: -> { new_record? || changed? }
  validate :first_wage_initial_date
  validate :transport_subsidy_if_base_salary_low

  attr_accessor :payroll_regeneration_job_enqueued

  before_create :set_wage_end_date, :update_last_wage_on_create
  before_update :update_last_wage_on_update
  before_destroy :prevent_last_wage_deletion
  after_destroy :update_last_wage_on_destroy
  after_commit :enqueue_payroll_regeneration_job

  def set_wage_end_date
    self.end_date = contract.end_date
  end

  def update_last_wage_on_destroy
    previous_wage = contract.wages.order(end_date: :desc).first
    previous_wage&.update_columns(end_date: contract.end_date)
  end

  def update_last_wage_on_create
    previous_wage = contract.wages.order(end_date: :desc).first
    previous_wage&.update_columns(end_date: initial_date - 1.day)
  end

  def update_last_wage_on_update
    previous_wage = contract.wages.order(end_date: :desc).second
    previous_wage&.update_columns(end_date: initial_date - 1.day)
  end

  def enqueue_payroll_regeneration_job
    return if payroll_regeneration_job_enqueued

    self.payroll_regeneration_job_enqueued = true

    RegenerateWorkerPayrollsJob.perform_later(worker, initial_date, end_date)
  end

  def prevent_last_wage_deletion
    if only_one_wage? && !destroyed_by_association.present?
      errors.add(:contract_id, :cannot_delete_last_wage)
      throw :abort
    end
  end

  def initial_date_in_contract_dates
    return unless wage_start_after_contract_end?

    errors.add(:initial_date, :out_of_contract_range)
  end

  def initial_date_greater_than_last
    return unless initial_date.is_a?(Date)

    if initial_date_before_last_wage? && !only_one_wage?
      errors.add(:initial_date, :should_be_after_last_wage)
    end
  end

  def first_wage_initial_date
    return if contract.wages.count.zero?

    if wage_start_before_contract? && new_record?
      errors.add(:initial_date, :out_of_contract_range)
    elsif wage_date_not_equal_to_contract? && only_one_wage?
      errors.add(:initial_date, :not_equal_to_contract)
    end
  end

  def transport_subsidy_if_base_salary_low
    return unless base_salary.present? && base_salary < (MINIMUM_WAGE * 2) && !transport_subsidy?

    errors.add(:transport_subsidy, :mandatory_transport_subsidy)
  end

  def initial_date_before_last_wage?
    last_wage_initial_date = contract.wages.order(initial_date: :desc).limit(1).pluck(:initial_date).first

    last_wage_initial_date.present? && initial_date <= last_wage_initial_date
  end

  def wage_start_before_contract?
    initial_date.is_a?(Date) && initial_date <= contract.initial_date
  end

  def wage_start_after_contract_end?
    initial_date.is_a?(Date) && contract.end_date.present? && initial_date > contract.end_date
  end

  def only_one_wage?
    contract.wages.count == 1
  end

  def wage_date_not_equal_to_contract?
    persisted? && initial_date != contract.initial_date
  end
end
