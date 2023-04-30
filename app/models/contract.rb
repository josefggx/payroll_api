class Contract < ApplicationRecord
  include DateConstants
  include PayrollHelper

  belongs_to :worker
  has_one :company, through: :worker
  has_many :wages, validate: true, dependent: :destroy

  validates :worker, presence: true
  validates :job_title, presence: true
  validates :health_provider, presence: true
  validates :term, inclusion: { in: CONTRACT_TERMS }
  validates :risk_type, presence: true, inclusion: { in: RISK_TYPES.keys }

  validates :initial_date,
            presence: { code: '0460' },
            comparison: { greater_than: MIN_VALID_DATE, code: '0461', if: -> { initial_date.present? } }

  validates :end_date,
            date: { code: '0462' },
            allow_blank: true,
            comparison: { greater_than_or_equal_to: :initial_date, code: '0463',
                          if: -> { initial_date.present? && end_date.present? } }

  validate :validate_end_date_presence

  attr_accessor :change_detected

  before_update :update_associated_wages
  after_update :delete_obsolete_payrolls

  def update_associated_wages
    return unless changed?

    newest_wage = wages.order(initial_date: :desc).first

    if should_update_newest_wage?(newest_wage, end_date)
      newest_wage&.update_columns(end_date:)
      newest_wage&.save
    else
      reset_wages_with_newest!(newest_wage, initial_date, end_date)
    end
  end

  def should_update_newest_wage?(newest_wage, end_date)
    end_date_changed? && (end_date.nil? ||
                         (!initial_date_changed? && newest_wage&.end_date.present? && end_date > newest_wage.end_date))
  end

  def reset_wages_with_newest!(newest_wage, initial_date, end_date)
    base_salary = newest_wage.base_salary
    transport_subsidy = newest_wage.transport_subsidy

    wages.delete_all
    wages.create(base_salary:, transport_subsidy:, initial_date:, end_date:)
  end

  def validate_end_date_presence
    if term == 'fixed' && end_date.blank?
      errors.add(:end_date, :missing_end_date)
    elsif term == 'indefinite' && end_date.present?
      errors.add(:end_date, :unexpected_end_date)
    end
  end

  def delete_obsolete_payrolls
    worker_payrolls = worker.payrolls

    initial_date = self.initial_date.beginning_of_month
    end_date = self.end_date&.end_of_month || Date.new(3000, 12, 31)

    payrolls_outside_range = worker_payrolls.reject do |payroll|
      payroll.period.start_date.between?(initial_date, end_date)
    end

    payrolls_outside_range.each(&:destroy)
  end
end
