require "test_helper"

module V1
  module Contracts
    class CurrentWageControllerTest < ActionDispatch::IntegrationTest
      include AuthHelper
      include ParsedResponse
      include WagesSupport
      include WageAsserts

      def setup
        @user = users(:valid_user)
        @company = companies(:company)
        @headers = auth_headers(@user)
        @contract = contracts(:contract)
        @wage = @contract.wages.order(initial_date: :desc).first
      end

      test 'should show current wage' do
        get_current_wage_show(@company.id, @contract.id, @headers)

        assert_response :success
        wage_response_asserts
      end

      test 'should update current wage' do
        put_current_wage_update(@company.id, @contract.id, wage_edited_params, @headers)

        assert_response :success
        wage_response_asserts
        assert_equal wage_edited_params[:wage][:base_salary].to_f, @wage.reload.base_salary, 'Base salary changed'
      end

      test 'should not update current wage with invalid params' do
        put_current_wage_update(@company.id, @contract.id, wage_invalid_params, @headers)

        assert_response :unprocessable_entity
        assert_equal response_error[0]['object'], 'Wage'
        assert_equal response_error[0]['message'], 'Salario base no puede estar en blanco'
      end

      test 'should destroy current wage' do
        delete_current_wage(@company.id, @contract.id, @headers)

        assert_response :no_content
        assert_not Wage.find_by(id: @wage.id), 'Wage was not destroyed'
      end

      private

      def get_current_wage_show(company_id, contract_id, headers = {})
        get v1_company_contract_current_wage_path(company_id, contract_id), headers: headers
      end

      def put_current_wage_update(company_id, contract_id, params, headers = {})
        put v1_company_contract_current_wage_path(company_id, contract_id), params: params, headers: headers
      end

      def delete_current_wage(company_id, contract_id, headers = {})
        delete v1_company_contract_current_wage_path(company_id, contract_id), headers: headers
      end
    end
  end
end
