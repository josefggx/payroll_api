require 'test_helper'

module V1
  class AuthenticationControllerTest < ActionDispatch::IntegrationTest
    include ParsedResponse

    setup do
      @user = users(:valid_user)
    end

    test 'should login and return token on successful login' do
      params = { email: @user.email, password: 'valid_password_1' }

      post_login(params)

      assert_response :success
      assert_not_nil response_data['token']
    end

    test 'should return error on invalid login' do
      params = { email: @user.email, password: 'wrong_password' }

      post_login(params)

      assert_response :unauthorized
      assert_equal 'Authentication', response_error['object']
      assert_equal response_error['message'], 'Correo electrónico o contraseña incorrectos'
    end

    private

    def post_login(params)
      post v1_auth_login_path params:
    end
  end
end
