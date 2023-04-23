class Wage < ApplicationRecord
  validates :base_salary, presence: true, numericality: { greater_than_or_equal_to: 0, code: "5002" }
  validates :transport_subsidy, presence: true
  validates :initial_date, presence: true

  belongs_to :contract
end
