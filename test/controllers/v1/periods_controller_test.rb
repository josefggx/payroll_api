require 'test_helper'
require_relative '../../../app/queries/periods_query'

module V1
  class PeriodsControllerTest < ActionDispatch::IntegrationTest
    include AuthHelper
    include ParsedResponse
    include PeriodAsserts
    include PeriodsSupport

    def setup
      @user = users(:valid_user)
      @headers = auth_headers(@user)
      @company = companies(:company)
      @period = periods(:period)
      @query = PeriodsQuery.new(@company)
    end

    test 'should get all periods with payrolls for a companies' do
      get_periods_index(@company.id, @headers)

      assert_response :success
      assert_equal @company.periods.size, response_data.size, 'Periods count on index'
    end

    test 'should create a period for a companies' do
      assert_difference('Period.count') do
        post_period_create(@company.id, period_params, @headers)
      end

      assert_response :created
      period_response_asserts
    end

    test 'should not create a period for a non-existent companies' do
      assert_no_difference('Period.count') do
        post_period_create(-1, period_params, @headers)
      end

      assert_response :not_found
      assert_equal response_error['message'], 'Registro no encontrado'
    end

    # test 'should get show' do
    #   get_period_show(@companies.id, @period.id, @headers)
    #
    #   assert_response :success
    #   assert_not_nil assigns(:period)
    #   assert_equal @period_with_info, assigns(:period)
    # end

    test 'should not show a period from a non-existent companies' do
      get_period_show(-1, @period.id, @headers)

      assert_response :not_found
      assert_equal response_error['message'], 'Registro no encontrado'
    end

    test 'should destroy a period' do
      assert_difference('Period.count', -1) do
        delete_period_destroy(@company.id, @period.id, @headers)
      end

      assert_response :no_content
    end
#
    test 'should not destroy a period from a non-existent companies' do
      assert_no_difference('Period.count') do
        delete_period_destroy(-1, @period.id, @headers)
      end

      assert_response :not_found
      assert_equal response_error['message'], 'Registro no encontrado'
    end

    private

    def get_periods_index(company_id, headers = {})
      get v1_company_periods_path(company_id), headers:
    end

    def post_period_create(company_id, params, headers = {})
      post v1_company_periods_path(company_id), params:, headers:
    end

    def get_period_show(company_id, id, headers = {})
      get v1_company_period_path(company_id, id), headers:
    end

    def delete_period_destroy(company_id, id, headers = {})
      delete v1_company_period_path(company_id, id), headers:
    end
  end
end
