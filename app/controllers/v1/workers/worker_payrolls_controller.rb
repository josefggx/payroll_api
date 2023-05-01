module V1
  module Workers
    class WorkerPayrollsController < ApplicationController
      before_action :set_company
      before_action :authorize
      before_action :set_worker

      def index
        @worker_payrolls = @worker.payrolls.includes(:period).order('periods.end_date DESC')
      end

      private

      def set_company
        @company = Company.find(params[:company_id])
      end

      def set_worker
        @worker = @company.workers.find(params[:worker_id])
      end

      def authorize
        render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
      end
    end
  end
end
