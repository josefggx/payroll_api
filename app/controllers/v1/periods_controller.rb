module V1
  class PeriodsController < ApplicationController
    before_action :set_company
    before_action :authorize
    before_action :set_period, only: %i[show destroy]

    def index
      periods_query = PeriodsQuery.new(@company)
      @periods = periods_query.periods_with_payrolls_totals
    end

    def create
      @period = Period.new(period_params)

      if @period.save
        GeneratePeriodPayrollsJob.perform_later(@period)

        render :create, status: :created
      else
        puts "ERRORS: #{@period.errors.inspect}"
        render_errors(@period.errors)
      end
    end

    def show
      periods_query = PeriodsQuery.new(@company)
      @period = periods_query.period_with_payrolls_and_worker_info(@period.id)

      render :show, status: :ok
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
      @period = @company.periods.find(params[:id])
    end

    def authorize
      render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
    end
  end
end
