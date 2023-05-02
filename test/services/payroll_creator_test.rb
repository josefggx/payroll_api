require 'test_helper'
require_relative '../../app/services/payroll_creator'

class PayrollCreatorTest < ActiveSupport::TestCase
  setup do
    @worker = workers(:worker)
    @period = periods(:period)
  end

  test "creates a payroll successfully" do
    result = PayrollCreator.call(@worker, @period)
    assert result[:success]
    assert result[:payroll].persisted?
    assert_equal @worker, result[:payroll].worker
    assert_equal @period, result[:payroll].period
    assert_equal 1_300_000, result[:payroll].base_salary
    assert_equal 140_606, result[:payroll].transport_subsidy
    assert_equal 0, result[:payroll].additional_salary_income
    assert_equal 0, result[:payroll].non_salary_income
    assert_equal 52_000, result[:payroll].worker_healthcare
    assert_equal 52_000, result[:payroll].worker_pension
    assert_equal 0, result[:payroll].solidarity_fund
    assert_equal 0, result[:payroll].subsistence_account
    assert_equal 0, result[:payroll].deductions
    assert_equal 0, result[:payroll].company_healthcare
    assert_equal 156_000, result[:payroll].company_pension
    assert_equal 6_786, result[:payroll].arl
    assert_equal 52_000, result[:payroll].compensation_fund
    assert_equal 0, result[:payroll].icbf
    assert_equal 0, result[:payroll].sena
    assert_equal 120_050, result[:payroll].severance.to_i
    assert_equal 14_406, result[:payroll].interest.to_i
    assert_equal 120_050, result[:payroll].premium.to_i
    assert_equal 54_166, result[:payroll].vacation.to_i
    assert_equal 1_336_606, result[:payroll].worker_payment.to_i
    assert_equal 1_964_065, result[:payroll].total_company_cost.to_i
  end

  test "returns errors if payroll can't be saved" do
    result = PayrollCreator.call(@worker, periods(:another_period))
    assert_not result[:success]
    assert result[:errors].any?
  end
end
