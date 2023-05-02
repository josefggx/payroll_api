require 'test_helper'
require_relative '../../app/services/payroll_calculator'

class PayrollCalculatorTest < ActiveSupport::TestCase
  def setup
    @worker = workers(:worker)
    @period = periods(:period)
  end

  test 'creates a payroll with values when worker has wages on period' do
    result = PayrollCalculator.call(@worker, @period)

    assert result, "Expected result to be truthy, but was #{result.inspect}"

    assert_equal 1_300_000, result[:base_salary], 'base salary should be correct'
    assert_equal 140_606, result[:transport_subsidy], 'transport subsidy should be correct'
    assert_equal 0, result[:additional_salary_income], 'additional salary income should be correct'
    assert_equal 0, result[:non_salary_income], 'non-salary income should be correct'
    assert_equal 52_000, result[:worker_healthcare], 'worker healthcare should be correct'
    assert_equal 52_000, result[:worker_pension], 'worker pension should be correct'
    assert_equal 0, result[:solidarity_fund], 'solidarity fund should be correct'
    assert_equal 0, result[:subsistence_account], 'subsistence account should be correct'
    assert_equal 0, result[:deductions], 'deductions should be correct'
    assert_equal 0, result[:company_healthcare], 'company healthcare should be correct'
    assert_equal 156_000, result[:company_pension], 'company pension should be correct'
    assert_equal 6_786, result[:arl], 'arl should be correct'
    assert_equal 52_000, result[:compensation_fund], 'compensation fund should be correct'
    assert_equal 0, result[:icbf], 'icbf should be correct'
    assert_equal 0, result[:sena], 'sena should be correct'
    assert_equal 120_050, result[:severance].to_i, 'severance should be correct'
    assert_equal 14_406, result[:interest].to_i, 'interest should be correct'
    assert_equal 120_050, result[:premium].to_i, 'premium should be correct'
    assert_equal 54_166, result[:vacation].to_i, 'vacation should be correct'
    assert_equal 1_336_606, result[:worker_payment].to_i, 'worker payment should be correct'
    assert_equal 1_964_065, result[:total_company_cost].to_i, 'total company should be correct'
  end

  test 'creates a payroll with values on 0 when worker has no wages on period' do
    result = PayrollCalculator.call(@worker, periods(:another_period))

    assert result, "Expected result to be truthy, but was #{result.inspect}"

    assert_equal 0, result[:base_salary], 'base salary should be correct'
    assert_equal 0, result[:transport_subsidy], 'transport subsidy should be correct'
    assert_equal 0, result[:additional_salary_income], 'additional salary income should be correct'
    assert_equal 0, result[:non_salary_income], 'non-salary income should be correct'
    assert_equal 0, result[:worker_healthcare], 'worker healthcare should be correct'
    assert_equal 0, result[:worker_pension], 'worker pension should be correct'
    assert_equal 0, result[:solidarity_fund], 'solidarity fund should be correct'
    assert_equal 0, result[:subsistence_account], 'subsistence account should be correct'
    assert_equal 0, result[:deductions], 'deductions should be correct'
    assert_equal 0, result[:company_healthcare], 'company healthcare should be correct'
    assert_equal 0, result[:company_pension], 'company pension should be correct'
    assert_equal 0, result[:arl], 'arl should be correct'
    assert_equal 0, result[:compensation_fund], 'compensation fund should be correct'
    assert_equal 0, result[:icbf], 'icbf should be correct'
    assert_equal 0, result[:sena], 'sena should be correct'
    assert_equal 0, result[:severance].to_i, 'severance should be correct'
    assert_equal 0, result[:interest].to_i, 'interest should be correct'
    assert_equal 0, result[:premium].to_i, 'premium should be correct'
    assert_equal 0, result[:vacation].to_i, 'vacation should be correct'
    assert_equal 0, result[:worker_payment].to_i, 'worker payment should be correct'
    assert_equal 0, result[:total_company_cost].to_i, 'total company should be correct'
  end
end
