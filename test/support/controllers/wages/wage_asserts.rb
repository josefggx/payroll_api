module WageAsserts
  def wage_response_asserts
    wage = Wage.find(response_data['id'])

    assert_subset response_data.keys, wage_valid_keys
    assert_equal wage.base_salary.to_s, response_data['base_salary']
    assert_equal wage.transport_subsidy, response_data['transport_subsidy']
    assert_equal wage.initial_date, Date.parse(response_data['initial_date'])
    assert_equal wage.contract_id, response_data['contract_id']
  end
end
