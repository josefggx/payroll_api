module V1
  class PayrollsController < ApplicationController
    before_action :set_company
    before_action :authorize
    before_action :set_payroll, only: %i[show destroy]

    def index
      @payrolls = @company.payrolls

      render json: @payrolls, status: :ok
    end


    def create
      result = PayrollCreator.call(payroll_params)

      if result[:success]
        @payroll = result[:payroll]
      else
        puts "ERRORES: #{result[:errors].inspect}"

        render_errors(result[:errors])
      end
    end

    def show
      @payroll = Payroll.find(params[:id])
      # @period = Period.includes(:payrolls).find(params[:id])

      render json: @payroll, status: :ok
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
      @payroll = Payroll.find(params[:id])
    end

    def authorize
      render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
    end
  end
end
