module V1
  class WorkersController < ApplicationController
    before_action :set_company
    before_action :authorize
    before_action :set_worker, only: %i[show update destroy]

    def index
      @workers = @company.workers
      render json: @workers, status: :ok
    end

    def create
      @worker = @company.workers.new(worker_params)

      if @worker.save
        render json: @worker, status: :created
      else
        render json: render_errors(@worker.errors), status: :unprocessable_entity
      end
    end

    def show
      render json: @worker
    end

    def update
      if @worker.update(worker_params)
        render json: @worker, status: :ok
      else
        render json: render_errors(@worker.errors), status: :unprocessable_entity
      end
    end

    def destroy
      if @worker.destroy
        head :no_content
      else
        render json: render_errors(@worker.errors), status: :unprocessable_entity
      end
    end

    private

    def set_company
      @company = Company.find(params[:company_id])
    end

    def set_worker
      @worker = @company.workers.find(params[:id])
    end

    def worker_params
      # params.require(:worker).permit(:name, :id_number, :job_title, :contract_category, :term, :base_salary,
      #                                :transport_subsidy, :initial_date, :end_date)
      params.require(:worker).permit(:name, :id_number)
    end

    def authorize
      render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
    end
  end
end
