require 'test_helper'

module V1
  class PayrollsControllerTest < ActionDispatch::IntegrationTest
    include AuthHelper
    include ParsedResponse
    include PayrollAsserts
    include PayrollsSupport

    def setup
      @user = users(:valid_user)
      @headers = auth_headers(@user)
      @company = companies(:company)
      @period = periods(:period)
      @worker = workers(:worker)
      @payroll = payrolls(:payroll)
    end

    test 'should get all payrolls for a companies' do
      get_payrolls_index(@company.id, @headers)

      assert_response :success
      assert_equal @company.payrolls.size, response_data.size, 'Payrolls count on index'
    end

    test 'should create a payroll for a worker in a period' do
      assert_difference('Payroll.count') do
        post_payroll_create(@company.id, payroll_params, @headers)
      end

      assert_response :created
      payroll_response_asserts
    end

    test 'should not create a payroll for a non-existent companies' do
      assert_no_difference('Payroll.count') do
        post_payroll_create(-1, payroll_params, @headers)
      end

      assert_response :not_found
      assert_equal response_error['message'], 'Registro no encontrado'
    end

    test 'should show a payroll' do
      get_payroll_show(@company.id, @payroll.id, @headers)

      assert_response :success
      payroll_response_asserts
    end

    test 'should not show a payroll from a non-existent companies' do
      get_payroll_show(-1, @payroll.id, @headers)

      assert_response :not_found
      assert_equal response_error['message'], 'Registro no encontrado'
    end

    test 'should destroy a payroll' do
      assert_difference('Payroll.count', -1) do
        delete_payroll_destroy(@company.id, @payroll.id, @headers)
      end

      assert_response :no_content
    end

    test 'should not destroy a payroll from a non-existent companies' do
      assert_no_difference('Payroll.count') do
        delete_payroll_destroy(-1, @payroll.id, @headers)
      end

      assert_response :not_found
      assert_equal response_error['message'], 'Registro no encontrado'
    end

    private

    def get_payrolls_index(company_id, headers = {})
      get v1_company_payrolls_path(company_id), headers:
    end

    def post_payroll_create(company_id, params, headers = {})
      post v1_company_payrolls_path(company_id), params:, headers:
    end

    def get_payroll_show(company_id, id, headers = {})
      get v1_company_payroll_path(company_id, id), headers:
    end

    def delete_payroll_destroy(company_id, id, headers = {})
      delete v1_company_payroll_path(company_id, id), headers:
    end
  end
end
