module V1
  class PeriodsController < ApplicationController
    before_action :set_company
    before_action :authorize
    before_action :set_period, only: %i[destroy]

    def index
      @periods = @company.periods

      render json: @periods, status: :ok
    end

    def create
      @period = Period.new(period_params)

      if @period.save
        render json: @period, status: :created
      else
        puts "ERRORS: #{@period.errors.inspect}"
        render_errors(@period.errors)
      end
    end

    def show
      @period = Period.find(params[:id])
      # @period = Period.includes(:payrolls).find(params[:id])

      render json: @period, status: :ok
    end

    def destroy
      if @period.destroy
        head :no_content
      else
        render_errors(@period.errors)
      end
    end

    private

    def period_params
      params.require(:period).permit(:year, :month).merge(company_id: params[:company_id])
    end

    def set_company
      @company = Company.find(params[:company_id])
    end

    def set_period
      @period = Period.find(params[:id])
    end

    def authorize
      render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
    end
  end
end

# def create
#   result = WorkerCreator.call(worker_create_params)
#
#   if result[:success]
#     @worker = result[:worker]
#   else
#     render_errors(*result[:errors])
#   end
# end
