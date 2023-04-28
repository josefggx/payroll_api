class PayrollCreator
  def self.call(params)
    new(params).create_payroll
  end

  def initialize(params)
    @params = params
  end

  def create_payroll
    payroll_fields = PayrollCalculator.call(worker, period)
    payroll = Payroll.new(period:, worker:, **payroll_fields)

    if payroll.save
      { success: true, payroll: }
    else
      { success: false, errors: payroll.errors }
    end
  end

  private

  def period
    Period.find(@params[:period_id])
  end

  def worker
    Worker.find(@params[:worker_id])
  end
end
