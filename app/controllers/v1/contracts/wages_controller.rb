module V1
  module Contracts
    class WagesController < ApplicationController
      before_action :set_company
      before_action :authorize
      before_action :set_contract, only: %i[index create]

      def index
        @wages = @contract.wages
      end

      def create
        @wage = @contract.wages.new(wage_params)

        if @wage.save
          render :create, status: :created
        else
          render_errors(@wage.errors)
        end
      end

      private

      def wage_params
        params.require(:wage).permit(:contract_id, :base_salary, :transport_subsidy, :initial_date, :end_date)
      end

      def set_company
        @company = Company.find(params[:company_id])
      end

      def set_contract
        @contract = Contract.find(params[:contract_id])
      end

      def authorize
        render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
      end
    end
  end
end
