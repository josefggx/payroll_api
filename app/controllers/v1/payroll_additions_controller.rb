module V1
  class PayrollAdditionsController < ApplicationController
    before_action :set_company
    before_action :authorize
    before_action :set_payroll_addition, only: %i[show update destroy]
    before_action :set_payroll, only: %i[create]

    def index
      @payroll_additions = @company.payroll_additions

      render json: @payroll_additions, status: :ok
    end

    def create
      @payroll_addition = PayrollAddition.new(payroll_addition_params)

      if @payroll_addition.save
        render json: @payroll_addition, status: :created
      else
        # puts "ERRORS: #{@payroll_addition.errors.inspect}"
        render_errors(@payroll_addition.errors)
      end
    end

    def show
      @payroll_addition = PayrollAddition.find(params[:id])

      render json: @payroll_addition, status: :ok
    end

    def update
      if @payroll_addition.update(payroll_addition_params)
        render json: @payroll_addition, status: :ok
      else
        render_errors(@payroll_addition.errors)
      end
    end

    def destroy
      if @payroll_addition.destroy
        head :no_content
      else
        render_errors(@payroll_addition.errors)
      end
    end

    private

    def payroll_addition_params
      params.require(:payroll_addition).permit(:payroll_id, :name, :addition_type, :amount)
    end

    def set_company
      @company = Company.find(params[:company_id])
    end

    def set_payroll
      @payroll = @company.payrolls.find(payroll_addition_params[:payroll_id])
    end

    def set_payroll_addition
      @payroll_addition = @company.payroll_additions.find(params[:id])
    end

    def authorize
      render_error_not_authorized(:company) unless @company && @company.user_id == @current_user.id
    end
  end
end
