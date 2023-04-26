# frozen_string_literal: true

module V1
  class AuthenticationController < ApplicationController
    skip_before_action :authentication_request

    def login
      @user = User.find_by_email(params[:email])

      if @user&.authenticate(params[:password])
        token = jwt_encode(user_id: @user.id)

        render json: { data: { token: } }, status: :ok
      else
        render_error_wrong_credentials
      end
    end
  end
end
