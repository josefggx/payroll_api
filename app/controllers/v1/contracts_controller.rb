module V1
  class ContractsController < ApplicationController
    before_action :set_company
    before_action :authorize
    before_action :set_contract, only: %i[update destroy]

    def index
      @contracts = @company.contracts.includes(worker: :wages)
    end

    def show
      @contract = Contract.includes(:worker, :wages).find(params[:id])
    end

    def update
      if @contract.update(contract_params)
        render json: @contract, status: :ok
      else
        render_errors(@contract.errors)
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
      params.require(:contract).permit(:worker_id, :job_title, :term, :health_provider,
                                       :risk_type, :initial_date, :end_date)
    end

    def authorize
      render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
    end
  end
end
