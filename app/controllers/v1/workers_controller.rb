module V1
  class WorkersController < ApplicationController
    before_action :set_company
    before_action :authorize
    before_action :set_worker, only: %i[update destroy]

    def index
      @workers = @company.workers.includes(:contract, :wages).all
    end

    def create
      result = WorkerCreator.call(worker_create_params)

      if result[:success]
        @worker = result[:worker]
      else
        render_errors(*result[:errors])
      end
    end

    def show
      @worker = @company.workers.includes(:company, :contract, :wages).find(params[:id])
    end

    def update
      if @worker.update(worker_update_params)
        render json: @worker, status: :ok
      else
        render_errors(@worker.errors)
      end
    end

    def destroy
      if @worker.destroy
        head :no_content
      else
        render_errors(@worker.errors)
      end
    end

    private

    def worker_create_params
      params.require(:worker).permit(:name, :id_number, :company_id, :job_title, :term, :risk_type,
                                     :health_provider, :base_salary, :transport_subsidy, :initial_date, :end_date)
            .merge(company_id: params[:company_id])
    end

    def worker_update_params
      params.require(:worker).permit(:name, :id_number)
    end

    def set_company
      @company = Company.find(params[:company_id])
    end

    def set_worker
      @worker = @company.workers.find(params[:id])
    end

    def authorize
      render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
    end
  end
end
