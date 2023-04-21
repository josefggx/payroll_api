module V1
  class UsersController < ApplicationController
    skip_before_action :authentication_request, only: %i[create index]

    before_action :set_user, only: %i[show update destroy]
    before_action :authorize, only: %i[show update destroy]

    def index
      @user = User.all
      render json: @user, status: :ok
    end

    def current
      render json: @current_user, status: :ok
    end

    def show
      render json: @user, status: :ok
    end

    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created
      else
        render json: render_errors(@user.errors), status: :unprocessable_entity
      end
    end

    def update
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: render_errors(@user.errors), status: :unprocessable_entity
      end
    end

    def destroy
      if @user.destroy
        head :no_content
      else
        render json: render_errors(@user.errors), status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def authorize
      render_error_not_authorized(:user) unless @user && @user.id == @current_user.id
    end
  end
end
