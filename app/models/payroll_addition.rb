class PayrollAddition < ApplicationRecord
  belongs_to :payroll
  has_one :company, through: :payroll
  has_one :period, through: :payroll
  has_one :worker, through: :payroll

  enum addition_type: {
    deduction: 'deduction',
    non_salary_income: 'non_salary_income',
    salary_income: 'salary_income'
  }

  attribute :addition_type, :enum

  scope :deductions, -> { where(addition_type: :deduction) }
  scope :non_salary_income, -> { where(addition_type: :non_salary_income) }
  scope :salary_income, -> { where(addition_type: :salary_income) }

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :addition_type, inclusion: { in: addition_types }

  validate :deduction_less_than_amount

  after_save :update_payroll
  before_destroy :update_payroll

  def update_payroll
    payroll.recalculate!
  end

  def deduction_less_than_amount
    old_amount = amount_was || 0
    new_deduction = amount - old_amount

    puts "amount = #{amount}"
    puts "old_amount = #{old_amount}"
    puts "new_deduction = #{new_deduction}"


    return unless deduction? && (new_deduction >= payroll.worker_payment)

    errors.add(:amount, :invalid_deduction)
  end
end
