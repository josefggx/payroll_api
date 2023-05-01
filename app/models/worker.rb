# == Schema Information
#
# Table name: workers
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  id_number  :integer          not null
#  company_id :uuid             not null
#
class Worker < ApplicationRecord
  include StringValidations

  belongs_to :company
  has_one :contract, validate: true, dependent: :destroy
  has_many :wages, through: :contract, validate: true
  has_many :payrolls, dependent: :destroy
  has_many :periods, through: :payrolls
  has_many :payroll_additions, through: :payrolls

  validates :name, presence: true,
                   length: { in: 3..30, if: -> { name.present? } },
                   format: { with: proc { |w| w.regex_valid_name }, if: -> { name.present? } }

  validates :id_number, presence: true,
                        uniqueness: true,
                        numericality: { greater_than: 0, if: -> { id_number.present? } },
                        length: { in: 6..10, if: -> { id_number.present? } }

  def find_worker_wages_for_period(period)
    wages.where("(:start_date BETWEEN wages.initial_date AND COALESCE(wages.end_date, '9999-12-31')) OR
                 (:end_date BETWEEN wages.initial_date AND COALESCE(wages.end_date, '9999-12-31')) OR
                 (wages.initial_date BETWEEN :start_date AND :end_date)", start_date: period.start_date,
                                                                          end_date: period.end_date)
         .order('wages.initial_date')
  end

  def valid_for_period?(period)
    find_worker_wages_for_period(period).any?
  end

  def regenerate_worker_payrolls!(initial_date, end_date)
    WorkerPayrollsRegenerator.call(self, initial_date, end_date)
  end
end
