class Contract < ApplicationRecord
  include DateConstants
  include PayrollHelper

  validates :worker, presence: true
  validates :job_title, presence: true
  validates :health_provider, presence: true
  validates :term, inclusion: { in: CONTRACT_TERMS }
  validates :risk_type, inclusion: { in: RISK_TYPES.keys }

  validates :initial_date,
            presence: { code: '0460' },
            comparison: { greater_than: MIN_VALID_DATE, code: '0461', if: -> { initial_date.present? } }

  validates :end_date,
            date: { code: '0462' },
            allow_blank: true,
            comparison: { greater_than_or_equal_to: :initial_date, code: '0463',
                          if: -> { initial_date.present? && end_date.present? } }

  validate :validate_end_date_presence

  belongs_to :worker
  has_many :wages, validate: true, dependent: :destroy

  before_update :update_associated_salaries

  def update_associated_salaries
    oldest_salary = wages.order(initial_date: :asc).first
    newest_salary = wages.order(initial_date: :desc).first
    newest_base_salary = newest_salary&.base_salary
    newest_transport_subsidiary = newest_salary&.transport_subsidy
    oldest_base_salary = oldest_salary&.base_salary
    oldest_transport_subsidiary = oldest_salary&.transport_subsidy

    if end_date_changed? && end_date.nil? && !initial_date_changed?
      newest_salary&.update_columns(end_date: end_date)
    elsif end_date_changed? && !initial_date_changed? && (newest_salary&.end_date.nil? || newest_salary.end_date <= end_date)
      newest_salary&.update_columns(end_date: end_date)
    elsif initial_date_changed? && initial_date <= oldest_salary&.end_date
      wages.destroy_all
      wages.create(base_salary: oldest_base_salary, transport_subsidy:  oldest_transport_subsidiary,
                   initial_date: initial_date, end_date: end_date)
    else
      wages.destroy_all
      wages.create(base_salary: newest_base_salary, transport_subsidy:  newest_transport_subsidiary,
                   initial_date: initial_date, end_date: end_date)
    end
  end

  def validate_end_date_presence
    if term == 'fixed' && end_date.blank?
      errors.add(:end_date, :missing_end_date)
    elsif term == 'indefinite' && end_date.present?
      errors.add(:end_date, :unexpected_end_date)
    end
  end
end
