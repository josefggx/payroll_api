class PayrollCreator
  def self.call(worker, period)
    new(worker, period).create_payroll
  end

  def initialize(worker, period)
    @worker = worker
    @period = period
  end

  def create_payroll
    payroll_fields = PayrollCalculator.call(@worker, @period)
    payroll = Payroll.new(worker: @worker, period: @period, **payroll_fields)

    if payroll.save
      { success: true, payroll: }
    else
      { success: false, errors: payroll.errors }
    end
  end
end
