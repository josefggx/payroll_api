# == Schema Information
#
# Table name: companies
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  nit        :integer          not null
#  user_id    :uuid             not null
#
class Company < ApplicationRecord
  include StringValidations

  belongs_to :user
  has_many :workers, dependent: :destroy
  has_many :contracts, through: :workers
  has_many :wages, through: :contracts
  has_many :periods, dependent: :destroy
  has_many :payrolls, through: :periods
  has_many :payroll_additions, through: :periods

  validates :nit, presence: true,
                  uniqueness: true,
                  numericality: { greater_than: 0, if: -> { nit.present? } },
                  length: { is: 9, if: -> { nit.present? } }

  validates :name, presence: true,
                   length: { in: 3..30, if: -> { name.present? } },
                   format: { with: proc { |w| w.regex_valid_name }, if: -> { name.present? } }

  def find_company_periods_between(initial_date, end_date)
    initial_date = initial_date.beginning_of_month
    end_date = end_date&.end_of_month || Date.new(3000, 12, 31)

    periods.where('(start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?)',
                  end_date, initial_date, initial_date, initial_date)
  end
end
