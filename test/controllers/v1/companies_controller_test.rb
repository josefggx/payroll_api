require 'test_helper'

module V1
  class CompaniesControllerTest < ActionDispatch::IntegrationTest
    include AuthHelper
    include ParsedResponse
    include CompanyAsserts
    include CompaniesSupport

    def setup
      @user = users(:valid_user)
      @headers = auth_headers(@user)
      @company = companies(:company)
      @other_company = companies(:another_company)
    end

    test 'should get all companies on index' do
      get_companies_index(@headers)

      assert_response :success
      assert_equal @user.companies.size, response_data.size, 'Companies count on index'
    end

    test 'should create companies' do
      assert_difference('Company.count') do
        post_company_create(company_params, @headers)
      end

      assert_response :created
      company_response_asserts
    end

    test 'should not create companies with bad params' do
      @company.errors.clear

      assert_no_difference('Company.count') do
        post_company_create(company_invalid_params, @headers)
      end

      assert_response :unprocessable_entity
      assert_equal response_error[0]['object'], 'Company'
      assert_equal response_error[0]['message'], 'NIT debe tener exactamente 9 dígitos'
    end

    test 'should show companies' do
      get_company_show(@company.id, @headers)

      assert_response :success
      company_response_asserts
    end

    test 'should not show other user companies' do
      get_company_show(@other_company.id, @headers)

      assert_response :forbidden
      assert_equal response_error['message'], 'No estás autorizado para realizar esta acción'
    end

    test 'should update companies' do
      put_company_update(@company.id, company_edited_params, @headers)

      assert_response :success
      company_response_asserts
    end

    test 'should not update companies with invalid params' do
      put_company_update(@company.id, company_invalid_params, @headers)

      assert_response :unprocessable_entity
      assert_equal response_error[0]['object'], 'Company'
      assert_equal response_error[0]['message'], 'NIT debe tener exactamente 9 dígitos'
    end

    test 'should not update other user companies' do
      put_company_update(@other_company.id, company_params, @headers)

      assert_response :forbidden
      assert_equal response_error['message'], 'No estás autorizado para realizar esta acción'
    end

    test 'should destroy companies' do
      assert_difference('Company.count', -1) do
        delete_company_destroy(@company.id, @headers)
      end

      assert_response :no_content
    end

    test 'should not destroy other companies' do
      assert_no_difference('Company.count') do
        delete_company_destroy(@other_company.id, @headers)
      end

      assert_response :forbidden
      assert_equal response_error['message'], 'No estás autorizado para realizar esta acción'
    end

    private

    def get_companies_index(headers = {})
      get v1_companies_path, headers:
    end

    def post_company_create(params, headers = {})
      post v1_companies_path, params:, headers:
    end

    def get_company_show(id, headers = {})
      get v1_company_path(id), headers:
    end

    def put_company_update(id, params, headers = {})
      put v1_company_path(id), params:, headers:
    end

    def delete_company_destroy(id, headers = {})
      delete v1_company_path(id), headers:
    end
  end
end
