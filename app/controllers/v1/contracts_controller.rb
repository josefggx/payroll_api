module V1
  class ContractsController < ApplicationController
    before_action :set_company
    before_action :authorize
    before_action :set_contract, only: %i[show update destroy]

    def index
      @contracts = @company.contracts
      render json: @contracts, status: :ok
    end

    def create
      @contract = @company.contracts.new(contract_params)

      if @contract.save
        render json: @contract, status: :created
      else
        render json: render_errors(@contract.errors), status: :unprocessable_entity
      end
    end

    def show
      render json: @contract
    end

    def update
      if @contract.update(contract_params)
        render json: @contract, status: :ok
      else
        render json: render_errors(@contract.errors), status: :unprocessable_entity
      end
    end

    def destroy
      if @contract.destroy
        head :no_content
      else
        render json: render_errors(@contract.errors), status: :unprocessable_entity
      end
    end

    private

    def set_company
      @company = Company.find(params[:company_id])
    end

    def set_contract
      @contract = @company.contracts.find(params[:id])
    end

    def contract_params
      params.require(:contract).permit(:worker_id, :job_title, :contract_category, :term,
                                       :health_provider, :risk_type, :initial_date, :end_date)
    end

    def authorize
      render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
    end
  end
end
