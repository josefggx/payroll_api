require 'test_helper'

class PeriodTest < ActiveSupport::TestCase
  include AssertColumnMatch

  def setup
    @company = companies(:company)
    @period = periods(:period)
  end

  test 'period database columns should match expected schema' do
    expected_columns = {
      id: [:uuid, false],
      start_date: [:date, false],
      end_date: [:date, false],
      company_id: [:uuid, false],
      created_at: [:datetime, false],
      updated_at: [:datetime, false]
    }

    Period.columns.each do |column|
      assert_column_match(column, expected_columns, Period.name)
    end
  end

  test 'belongs_to :companies association' do
    assert_equal @company, @period.company, 'association between period and companies'
  end

  test 'has_many :payrolls association' do
    payroll = payrolls(:payroll)
    @period.payrolls << payroll

    assert_includes @period.payrolls, payroll, 'association between period and payrolls'
  end

  test 'has_many :payroll_additions through :payrolls association' do
    payroll_addition = payroll_additions(:payroll_addition_one)
    payroll = payrolls(:payroll)
    payroll.payroll_additions << payroll_addition
    @period.payrolls << payroll

    assert_includes @period.payroll_additions, payroll_addition, 'association between period and payroll_additions'
  end

  test 'should validate presence of start date' do
    @period.start_date = nil

    assert_not @period.valid?
    assert @period.errors[:start_date].present?, 'error without start date'
  end

  test 'should be invalid without a companies' do
    @period.company = nil

    assert_not @period.valid?, 'should be invalid without a companies'
    assert @period.errors[:company].present?, 'should have an error message for companies'
  end


  test 'should be invalid with a non-unique start_date for the same companies' do
    @period.save

    new_period = Period.new(start_date: "2023-01-01", end_date: "2023-01-31", company: @company)

    assert_not new_period.valid?
    assert new_period.errors[:start_date].present?, 'error with non-unique start_date'
  end
end
