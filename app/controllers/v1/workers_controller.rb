module V1
  class WorkersController < ApplicationController
    before_action :set_company
    before_action :authorize
    before_action :set_worker, only: %i[show update destroy]

    def index
      @workers = @company.workers.includes(:contract, :wages).all
    end

    def create
      result = WorkerCreatorService.create_worker(params)
      @worker = result[:worker]

      if @worker.persisted?
        @worker
      else
        render json: render_errors(*result.values), status: :unprocessable_entity
      end
    end

    def show
      @worker = Worker.includes(:company, :contract, :wages).find(params[:id])
    end

    def update
      if @worker.update(worker_update_params)
        render json: @worker, status: :ok
      else
        render json: render_errors(@worker), status: :unprocessable_entity
      end
    end

    def destroy
      if @worker.destroy
        head :no_content
      else
        render json: render_errors(@worker), status: :unprocessable_entity
      end
    end

    private

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
