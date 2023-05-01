module V1
  class CompaniesController < ApplicationController
    before_action :set_company, only: %i[show update destroy]
    before_action :authorize, only: %i[show update destroy]

    def index
      @companies = @current_user.companies
    end

    def create
      @company = Company.new(company_params)

      if @company.save
        render :create, status: :created
      else
        render_errors(@company.errors)
      end
    end

    def show
      @company
    end

    def update
      if @company.update(company_params)
        render :create, status: :ok
      else
        render_errors(@company.errors)
      end
    end

    def destroy
      if @company.destroy
        head :no_content
      else
        render_errors(@company.errors)
      end
    end

    private

    def company_params
      params.require(:company).permit(:name, :nit).merge(user_id: @current_user.id)
    end

    def set_company
      @company = Company.find(params[:id])
    end

    def authorize
      render_error_not_authorized(:user) unless @company && @company.user_id == @current_user.id
    end
  end
end
