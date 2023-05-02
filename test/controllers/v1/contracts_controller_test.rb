require 'test_helper'

module V1
  class ContractsControllerTest < ActionDispatch::IntegrationTest
    include AuthHelper
    include ParsedResponse
    include ContractAsserts
    include ContractsSupport

    def setup
      @user = users(:valid_user)
      @headers = auth_headers(@user)
      @company = companies(:company)
      @other_company = companies(:another_company)
      @worker = workers(:worker)
      @contract = contracts(:contract)
    end

    test 'should get all contracts for a companies' do
      get_contracts_index(@company.id, @headers)

      assert_response :success
      assert_equal @company.contracts.size, response_data.size, 'Contracts count on index'
    end

    test 'should show contract' do
      get_contract_show(@company.id, @contract.id, @headers)

      assert_response :success
      contract_response_asserts
    end

    test 'should update contract' do
      put_contract_update(@company.id, @contract.id, contract_edited_params, @headers)

      assert_response :success
      contract_response_asserts
    end

    test 'should not update contract with invalid params' do
      put_contract_update(@company.id, @contract.id, contract_invalid_params, @headers)

      assert_response :unprocessable_entity
      assert_equal response_error[0]['object'], 'Contract'
      assert_equal response_error[0]['message'], 'Fecha final debe estar presente para los contratoa a término fijo'
    end

    test 'should not show contract from other companies' do
      get_contract_show(@company.id, contracts(:another_contract).id, @headers)

      assert_response :not_found
      assert_equal response_error['message'], 'Registro no encontrado'
    end

    test 'should not update contract from other companies' do
      put_contract_update(@company.id, contracts(:another_contract).id, contract_edited_params, @headers)

      assert_response :not_found
      assert_equal response_error['message'], 'Registro no encontrado'
    end

    private

    def get_contracts_index(company_id, headers = {})
      get v1_company_contracts_path(company_id), headers: headers
    end

    def get_contract_show(company_id, id, headers = {})
      get v1_company_contract_path(company_id, id), headers: headers
    end

    def put_contract_update(company_id, id, params, headers = {})
      put v1_company_contract_path(company_id, id), params: params, headers: headers
    end
  end
end
