class Wage < ApplicationRecord
  include PayrollHelper

  belongs_to :contract
  has_one :company, through: :contract

  validates :base_salary, presence: true, numericality: { greater_than_or_equal_to: 0, code: '5002' }
  validates :transport_subsidy, inclusion: { in: [true, false] }
  validates :initial_date, presence: true, date: true

  validate :initial_date_in_contract_dates
  validate :initial_date_greater_than_last, if: -> { new_record? || changed? }
  validate :first_wage_initial_date
  validate :transport_subsidy_if_base_salary_low

  before_create :set_wage_end_date, :update_last_wage_on_create
  before_update :update_last_wage_on_update
  after_destroy :update_last_wage_on_destroy

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

  def initial_date_in_contract_dates
    return unless initial_date.is_a?(Date) && contract.end_date.present? && initial_date > contract.end_date

    errors.add(:initial_date, :out_of_contract_end_date)
  end

  def initial_date_greater_than_last
    return unless initial_date.is_a?(Date)

    last_wage_initial_date = contract.wages.order(initial_date: :desc).limit(1).pluck(:initial_date).first

    return unless last_wage_initial_date.present? && initial_date < last_wage_initial_date

    errors.add(:initial_date, :invalid)
  end

  def first_wage_initial_date
    return if contract.wages.count.zero?

    if initial_date <= contract.initial_date && new_record?
      errors.add(:initial_date, :out_of_contract_range)
    elsif persisted? && contract.wages.count == 1
      errors.add(:initial_date, :not_equal_to_contract) if initial_date != contract.initial_date
    end
  end

  def transport_subsidy_if_base_salary_low
    return unless base_salary.present? && base_salary < (MINIMUM_WAGE * 2) && !transport_subsidy?

    errors.add(:transport_subsidy, :mandatory_transport_subsidy)
  end
end
