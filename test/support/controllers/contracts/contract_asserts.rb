module ContractAsserts
  def contract_response_asserts
    contract = Contract.find(response_data['id'])

    assert_subset response_data.keys, contract_valid_keys
    assert_equal contract.id, response_data['id']
    assert_equal contract.job_title, response_data['job_title']
    assert_equal contract.term, response_data['contract_term']
    assert_equal contract.risk_type, response_data['risk_type']
    assert_equal contract.health_provider, response_data['health_provider']
    assert_equal contract.initial_date, Date.parse(response_data['initial_date'])
    assert_equal contract.end_date, Date.parse(response_data['end_date'])
  end
end
