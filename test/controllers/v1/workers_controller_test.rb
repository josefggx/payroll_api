require 'test_helper'

module V1
  class WorkersControllerTest < ActionDispatch::IntegrationTest
    include AuthHelper
    include ParsedResponse
    include WorkerAsserts
    include WorkersSupport

    def setup
      @user = users(:valid_user)
      @headers = auth_headers(@user)
      @company = companies(:company)
      @other_company = companies(:another_company)
      @worker = workers(:worker)
    end

    test 'should get all workers for a companies' do
      get_workers_index(@company.id, @headers)

      assert_response :success
      assert_equal @company.workers.size, response_data.size, 'Workers count on index'
    end

    test 'should create worker for a companies' do
      assert_difference('Worker.count') do
        post_worker_create(@company.id, worker_params, @headers)
      end

      assert_response :created
      worker_response_asserts
    end

    test 'should not create worker for other companies' do
      assert_no_difference('Worker.count') do
        post_worker_create(@other_company.id, worker_params, @headers)
      end

      assert_response :forbidden
      assert_equal response_error['message'], 'No estás autorizado para realizar esta acción'
    end

    test 'should not create worker with invalid params' do
      @worker.errors.clear

      assert_no_difference('Worker.count') do
        post_worker_create(@company.id, worker_invalid_params, @headers)
      end

      assert_response :unprocessable_entity
      assert_equal response_error[0]['object'], 'Worker'
      assert_equal response_error[0]['message'], 'Nombre no puede estar en blanco'
    end

    test 'should show worker' do
      get_worker_show(@company.id, @worker.id, @headers)

      assert_response :success
      worker_response_asserts
    end

    test 'should not show worker from other companies' do
      get_worker_show(@company.id, workers(:another_worker).id, @headers)

      assert_response :not_found
      assert_equal response_error['message'], 'Registro no encontrado'
    end

    test 'should update worker' do
      put_worker_update(@company.id, @worker.id, worker_edited_params, @headers)

      assert_response :success
      worker_response_asserts
    end

    test 'should not update worker with invalid params' do
      put_worker_update(@company.id, @worker.id, worker_invalid_params, @headers)

      assert_response :unprocessable_entity
      assert_equal response_error[0]['object'], 'Worker'
      assert_equal response_error[0]['message'], 'Nombre no puede estar en blanco'
    end

    test 'should not update worker from other companies' do
      put_worker_update(@company.id, workers(:another_worker).id, worker_invalid_params, @headers)

      assert_response :not_found
      assert_equal response_error['message'], 'Registro no encontrado'
    end

    test 'should destroy worker' do
      assert_difference('Worker.count', -1) do
        delete_worker_destroy(@company.id, @worker.id, @headers)
      end

      assert_response :no_content
    end

    test 'should not destroy worker from other companies' do
      assert_no_difference('Worker.count') do
        delete_worker_destroy(@company.id, workers(:another_worker), @headers)
      end

      assert_response :not_found
      assert_equal response_error['message'], 'Registro no encontrado'
    end

    private

    def get_workers_index(company_id, headers = {})
      get v1_company_workers_path(company_id), headers:
    end

    def post_worker_create(company_id, params, headers = {})
      post v1_company_workers_path(company_id), params: params, headers: headers
    end

    def get_worker_show(company_id, id, headers = {})
      get v1_company_worker_path(company_id, id), headers:
    end

    def put_worker_update(company_id, id, params, headers = {})
      put v1_company_worker_path(company_id, id), params: params, headers: headers
    end

    def delete_worker_destroy(company_id, id, headers = {})
      delete v1_company_worker_path(company_id, id), headers:
    end
  end
end
