require 'test_helper'

class PayrollAdditionTest < ActiveSupport::TestCase
  include AssertColumnMatch

  def setup
    @company = companies(:company)
    @period = periods(:period_two)
    @worker = workers(:worker)
    @payroll = payrolls(:payroll)
    @payroll_addition = payroll_additions(:payroll_addition_one)
  end

  test 'payroll_addition database columns should match expected schema' do
    expected_columns = {
      id: [:uuid, false],
      payroll_id: [:uuid, false],
      name: [:string, false],
      amount: [:decimal, false],
      addition_type: [:enum, false],
      created_at: [:datetime, false],
      updated_at: [:datetime, false]
    }

    PayrollAddition.columns.each do |column|
      assert_column_match(column, expected_columns, PayrollAddition.name)
    end
  end

  test 'belongs_to :payroll association' do
    assert_equal @payroll, @payroll_addition.payroll, 'association between payroll_addition and payroll'
  end

  test 'has_one :company through :payroll association' do
    assert_equal @company, @payroll_addition.company, 'association between payroll_addition and company'
  end

  test 'has_one :period through :payroll association' do
    assert_equal periods(:another_period), @payroll_addition.period, 'association between payroll_addition and period'
  end

  test 'has_one :worker through :payroll association' do
    assert_equal @worker, @payroll_addition.worker, 'association between payroll_addition and worker'
  end

  test 'enum :addition_type' do
    payroll_addition = PayrollAddition.new(name: 'Test Deduction', amount: 100, addition_type: :deduction)

    assert payroll_addition.deduction?, 'should be of addition_type deduction'
    assert_not payroll_addition.non_salary_income?, 'should not be of addition_type non_salary_income'
    assert_not payroll_addition.salary_income?, 'should not be of addition_type salary_income'
  end

  test 'scope :deductions' do
    assert_not_includes PayrollAddition.deductions, payroll_additions(:payroll_addition_one), 'should include payroll_addition_one'
    assert_includes PayrollAddition.deductions, payroll_additions(:payroll_addition_two), 'should not include payroll_addition_two'
  end

  test 'should validate presence of name' do
    payroll_addition = @payroll.payroll_additions.create(amount: 1, addition_type: 'deduction')

    assert_not payroll_addition.valid?, 'should be invalid without name'

    assert payroll_addition.errors[:name].present?, 'should have an error message for name'
  end
end
