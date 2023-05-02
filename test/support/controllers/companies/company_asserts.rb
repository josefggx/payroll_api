module CompanyAsserts
  def company_response_asserts
    company = Company.find(response_data['id'])

    assert_subset response_data.keys, company_valid_keys
    assert_equal company.id, response_data['id']
    assert_equal company.name, response_data['name']
    assert_equal company.nit, response_data['nit']
    assert_equal company.user_id, response_data['user_id']
  end
end
