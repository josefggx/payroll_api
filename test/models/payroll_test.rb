require 'test_helper'

class PayrollsControllerTest < ActionDispatch::IntegrationTest
  include AssertColumnMatch

  def setup
    @company = companies(:company)
    @period = periods(:period)
    @worker = workers(:worker)
    @payroll = payrolls(:payroll)
  end

  test 'payroll database columns should match expected schema' do
    expected_columns = {
      id: [:uuid, false],
      period_id: [:uuid, false],
      worker_id: [:uuid, false],
      base_salary: [:decimal, false],
      transport_subsidy: [:decimal, false],
      additional_salary_income: [:decimal, false],
      non_salary_income: [:decimal, false],
      worker_healthcare: [:decimal, false],
      worker_pension: [:decimal, false],
      solidarity_fund: [:decimal, false],
      subsistence_account: [:decimal, false],
      deductions: [:decimal, false],
      company_healthcare: [:decimal, false],
      company_pension: [:decimal, false],
      arl: [:decimal, false],
      compensation_fund: [:decimal, false],
      icbf: [:decimal, false],
      sena: [:decimal, false],
      severance: [:decimal, false],
      interest: [:decimal, false],
      premium: [:decimal, false],
      vacation: [:decimal, false],
      worker_payment: [:decimal, false],
      total_company_cost: [:decimal, false],
      created_at: [:datetime, false],
      updated_at: [:datetime, false]
    }

    Payroll.columns.each do |column|
      assert_column_match(column, expected_columns, Payroll.name)
    end
  end

  test 'belongs_to :period association' do
    assert_equal periods(:another_period), @payroll.period, 'association between payroll and period'
  end

  test 'belongs_to :worker association' do
    assert_equal @worker, @payroll.worker, 'association between payroll and worker'
  end

  test 'has_many :payroll_additions association' do
    payroll_addition = payroll_additions(:payroll_addition_one)
    @payroll.payroll_additions << payroll_addition

    assert_includes @payroll.payroll_additions, payroll_addition, 'association between payroll and payroll_additions'
  end

  test 'has_one :company through :period association' do
    assert_equal @company, @payroll.company, 'association between payroll and company'
  end


  test 'should validate worker is valid for the period' do
    period = periods(:period_two)
    worker = workers(:worker)

    payroll = Payroll.new(worker: worker, period: period)

    assert_not payroll.valid?, 'should be invalid with worker not valid for period'
    assert payroll.errors[:worker_id].present?, 'should have an error message for worker_id'
  end

  test 'should validate uniqueness of worker_id within scope of period_id' do
    payroll = Payroll.new(worker: @worker, period: periods(:period_two))

    assert_not payroll.valid?, 'should be invalid with non-unique worker_id within scope of period_id'

    assert payroll.errors[:worker_id].present?, 'only one payroll - worker combo per period'
  end

  test 'should recalculate payroll' do
    result = @payroll.recalculate!
    assert(result.is_a?(Payroll) || result == false, 'recalculate! should return a payroll object or false')
  end
end
