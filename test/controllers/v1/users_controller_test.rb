require 'test_helper'

module V1
  class UsersControllerTest < ActionDispatch::IntegrationTest
    include AuthHelper
    include ParsedResponse
    include UserAsserts
    include UserSupport

    def setup
      @user = users(:valid_user)
      @headers = auth_headers(@user)
      @other_user = users(:another_valid_user)
      @other_headers = auth_headers(@other_user)
    end

    test 'should get all workers on index' do
      get_users_index

      assert_response :success
      assert_equal User.all.size, response_data.size, 'Users count on index'
    end

    test 'should create user' do
      assert_difference('User.count') do
        post_user_create(user_params)
      end

      assert_response :created
      user_response_asserts
    end

    test 'should not create user with bad params' do
      assert_no_difference('User.count') do
        post_user_create(user_invalid_params)
      end

      assert_response :unprocessable_entity
      assert_equal response_error[0]['object'], 'User'
      assert_equal response_error[0]['message'], "Correo electrónico no puede estar en blanco"
    end

    test 'should show user' do
      get_user_show(@user.id, @headers)

      assert_response :success
      user_response_asserts
    end

    test 'should not show other users' do
      get_user_show(@user.id, @other_headers)

      assert_response :forbidden
      assert_equal response_error['message'], 'No estás autorizado para realizar esta acción'
    end

    test 'should update user' do
      put_user_update(@user.id, user_edited_params, @headers)

      assert_response :success
      user_response_asserts
    end

    test 'should not update user with invalid params' do
      put_user_update(@user.id, user_invalid_params, @headers)

      assert_response :unprocessable_entity
      assert_equal response_error[0]['object'], 'User'
      assert_equal response_error[0]['message'], "Correo electrónico no puede estar en blanco"
    end

    test 'should not update other users' do
      put_user_update(@user.id, user_params, @other_headers)

      assert_response :forbidden
      assert_equal response_error['message'], 'No estás autorizado para realizar esta acción'
    end

    test 'should destroy user' do
      assert_difference('User.count', -1) do
        delete_user_destroy(@user.id, @headers)
      end

      assert_response :no_content
    end

    test 'should not destroy other users' do
      assert_no_difference('User.count') do
        delete_user_destroy(@user.id, @other_headers)
      end

      assert_response :forbidden
      assert_equal response_error['message'], 'No estás autorizado para realizar esta acción'
    end

    private

    def get_users_index(headers = {})
      get v1_users_path, headers:
    end

    def post_user_create(params, headers = {})
      post v1_users_path, params:, headers:
    end

    def get_user_show(id, headers = {})
      get v1_user_path(id), headers:
    end

    def put_user_update(id, params, headers = {})
      put v1_user_path(id), params:, headers:
    end

    def delete_user_destroy(id, headers = {})
      delete v1_user_path(id), headers:
    end
  end
end
