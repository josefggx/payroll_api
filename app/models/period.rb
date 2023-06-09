# == Schema Information
#
# Table name: periods
#
#  id         :uuid             not null, primary key
#  company_id :uuid             not null
#  start_date :date             not null
#  end_date   :date             not null
#
class Period < ApplicationRecord
  include StringValidations

  belongs_to :company
  has_many :payrolls, dependent: :destroy
  has_many :payroll_additions, through: :payrolls

  attr_accessor :year, :month

  validate :validate_year
  validate :validate_month
  validate :validate_unique_date

  before_create :calculate_dates

  def calculate_dates
    self.start_date = Date.new(year.to_i, month.to_i, 1)
    self.end_date = start_date.end_of_month
  end

  private

  def validate_year
    errors.add(:start_date, :invalid_year) unless valid_year?
  end

  def validate_month
    errors.add(:start_date, :invalid_month) unless valid_month?
  end

  def validate_unique_date
    return unless valid_year? && valid_month?

    start_date = Date.new(year.to_i, month.to_i, 1)

    if company.periods.exists?(start_date:)
      errors.add(:start_date, :not_unique)
    end
  end

  def valid_year?
    year.present? && regex_valid_year.match?(year.to_s)
  end

  def valid_month?
    month.present? && regex_valid_month.match?(month.to_s)
  end
end
