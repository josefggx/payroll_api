# frozen_string_literal: true

module V1
  class AuthenticationController < ApplicationController
    skip_before_action :authentication_request

    def login
      @user = User.find_by_email(params[:email])

      puts "USER: #{@user}"

      if @user&.authenticate(params[:password])
        token = jwt_encode(user_id: @user.id)

        render json: { token: }, status: :ok
      else
        render json: { error: { message: 'Email or password are invalid.', code: '0001', object: 'Authentication' } },
               status: :unauthorized
      end
    end
  end
end
