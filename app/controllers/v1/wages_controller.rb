module V1
  class WagesController < ApplicationController
    before_action :set_company
    before_action :authorize
    before_action :set_wage, only: %i[show update destroy]

    def index
      @wages = @company.wages
      render json: @wages, status: :ok
    end

    def create
      @wage = @company.wages.new(wage_params)

      if @wage.save
        render json: @wage, status: :created
      else
        render json: render_errors(@wage.errors), status: :unprocessable_entity
      end
    end

    def show
      render json: @wage
    end

    def update
      if @wage.update(wage_params)
        render json: @wage, status: :ok
      else
        render json: render_errors(@wage.errors), status: :unprocessable_entity
      end
    end

    def destroy
      if @wage.destroy
        head :no_content
      else
        render json: render_errors(@wage.errors), status: :unprocessable_entity
      end
    end

    private

    def wage_params
      params.require(:wage).permit(:base_salary, :transport_subsidy, :initial_date, :end_date, :contract_id)
    end

    def set_company
      @company = Company.find(params[:company_id])
    end

    def set_wage
      @wage = @company.wages.find(params[:id])
    end

    def authorize
      render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
    end
  end
end
