module V1
  module Periods
    class PeriodPayrollsController < ApplicationController
      before_action :set_company
      before_action :authorize
      before_action :set_period

      def index
        @period_payrolls = @period.payrolls.includes(:worker).order('workers.name ASC')
      end

      private

      def set_company
        @company = Company.find(params[:company_id])
      end

      def set_period
        @period = @company.periods.find(params[:period_id])
      end

      def authorize
        render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
      end
    end
  end
end
