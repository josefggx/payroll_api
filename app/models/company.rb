class Company < ApplicationRecord
  belongs_to :user
  has_many :workers, dependent: :destroy
  has_many :contracts, through: :workers
  has_many :wages, through: :contracts
  has_many :periods, dependent: :destroy
  has_many :payrolls, through: :periods
  has_many :payroll_additions, through: :periods

  validates :nit, presence: { code: '0201' },
                  uniqueness: { code: '0202' },
                  numericality: { greater_than: 0, code: '0203', if: -> { nit.present? } },
                  length: { is: 9, code: '0204', if: -> { nit.present? } }

  validates :name, presence: { code: '0211' }, length: { in: 3..30, code: '0212' }

  def find_company_periods_between(initial_date, end_date)
    initial_date = initial_date.beginning_of_month
    end_date = end_date&.end_of_month || Date.new(3000, 12, 31)

    periods.where('(start_date <= ? AND end_date >= ?)
                 OR (start_date <= ? AND end_date >= ?)',
                  end_date, initial_date, initial_date, initial_date)
  end
end
