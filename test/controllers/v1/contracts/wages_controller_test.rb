require "test_helper"

module V1
  module Contracts
    class WagesControllerTest < ActionDispatch::IntegrationTest
      include AuthHelper
      include ParsedResponse
      include WagesSupport
      include WageAsserts

      def setup
        @user = users(:valid_user)
        @headers = auth_headers(@user)
        @company = companies(:company)
        @contract = contracts(:contract)
        @worker = workers(:worker)
        @wage = wages(:wage)
      end

      test 'should get all wages for a contract' do
        get_wages_index(@company.id, @contract.id, @headers)

        assert_response :success
        assert_equal @contract.wages.size, response_data.size, 'Wages count on index'
      end


      test 'should create wage' do
        assert_difference('Wage.count') do
          post_create_wage(@company.id, @contract.id, wage_params, @headers)
        end

        assert_response :success
        wage_response_asserts
      end

      test 'should not create wage with invalid params' do
        assert_no_difference('Wage.count') do
          post_create_wage(@company.id, @contract.id, wage_invalid_params, @headers)
        end

        assert_response :unprocessable_entity
        assert_equal response_error[0]['object'], 'Wage'
        assert_equal response_error[0]['message'], "Salario base no puede estar en blanco"
      end

      private

      def get_wages_index(company_id, contract_id, headers = {})
        get v1_company_contract_wages_path(company_id, contract_id), headers: headers
      end

      def post_create_wage(company_id, contract_id, params, headers = {})
        post v1_company_contract_wages_path(company_id, contract_id), params: params, headers: headers
      end
    end
  end
end
