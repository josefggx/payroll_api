module V1
  module Contracts
    class CurrentWageController < ApplicationController
      before_action :set_company
      before_action :authorize
      before_action :set_current_wage

      def show
        @current_wage
      end

      def update
        if @current_wage.update(wage_params)
          render :update, status: :ok
        else
          render_errors(@current_wage&.errors)
        end
      end

      def destroy
        if @current_wage.destroy
          head :no_content
        else
          render_errors(@current_wage.errors)
        end
      end

      private

      def wage_params
        params.require(:wage).permit(:contract_id, :base_salary, :transport_subsidy, :initial_date, :end_date)
      end

      def set_company
        @company = Company.find(params[:company_id])
      end

      def set_current_wage
        @contract = Contract.find(params[:contract_id])
        @current_wage = @contract.wages.order(initial_date: :desc).first
      end

      def authorize
        render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
      end
    end
  end
end
