module V1
  class PayrollsController < ApplicationController
    before_action :set_company
    before_action :authorize
    before_action :set_payroll, only: %i[show destroy]
    before_action :set_worker, only: %i[create]
    before_action :set_period, only: %i[create]

    def index
      @payrolls = @company.payrolls.includes(:period, :worker)
                          .order('periods.end_date DESC, workers.name')
                          .references(:periods, :workers)
    end

    def create
      result = PayrollCreator.call(@worker, @period)

      if result[:success]
        @payroll = result[:payroll]
        render :create, status: :created
      else
        render_errors(result[:errors])
      end
    end

    def show
      @payroll
    end

    def destroy
      if @payroll.destroy
        head :no_content
      else
        render_errors(@payroll.errors)
      end
    end

    private

    def payroll_params
      params.require(:payroll).permit(:period_id, :worker_id)
    end

    def set_company
      @company = Company.find(params[:company_id])
    end

    def set_payroll
      @payroll = @company.payrolls.includes(:period, :worker).find(params[:id])
    end

    def set_worker
      @worker = @company.workers.find(payroll_params[:worker_id])
    end

    def set_period
      @period = @company.periods.find(payroll_params[:period_id])
    end

    def authorize
      render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
    end
  end
end
