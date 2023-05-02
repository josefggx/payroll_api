module PayrollAsserts
  def payroll_response_asserts
    payroll = Payroll.find(response_data['id'])

    assert_subset response_data.keys, payroll_valid_keys
    assert_equal payroll.period_id, response_data['period_id']
    assert_equal payroll.worker_id, response_data['worker_id']
    assert_equal payroll.base_salary.to_s, response_data['base_salary']
    assert_equal payroll.transport_subsidy.to_s, response_data['transport_subsidy']
    assert_equal payroll.additional_salary_income.to_s, response_data['additional_salary_income']
    assert_equal payroll.non_salary_income.to_s, response_data['non_salary_income']
    assert_equal payroll.worker_healthcare.to_s, response_data['worker_healthcare']
    assert_equal payroll.worker_pension.to_s, response_data['worker_pension']
    assert_equal payroll.solidarity_fund.to_s, response_data['solidarity_fund']
    assert_equal payroll.subsistence_account.to_s, response_data['subsistence_account']
    assert_equal payroll.deductions.to_s, response_data['deductions']
    assert_equal payroll.company_healthcare.to_s, response_data['company_healthcare']
    assert_equal payroll.company_pension.to_s, response_data['company_pension']
    assert_equal payroll.arl.to_s, response_data['arl']
    assert_equal payroll.compensation_fund.to_s, response_data['compensation_fund']
    assert_equal payroll.icbf.to_s, response_data['icbf']
    assert_equal payroll.sena.to_s, response_data['sena']
    assert_equal payroll.severance.to_s, response_data['severance']
    assert_equal payroll.interest.to_s, response_data['interest']
    assert_equal payroll.premium.to_s, response_data['premium']
    assert_equal payroll.vacation.to_s, response_data['vacation']
    assert_equal payroll.worker_payment.to_s, response_data['worker_payment']
    assert_equal payroll.total_company_cost.to_s, response_data['total_company_cost']
  end
end
