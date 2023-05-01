class PayrollUpdater
  def self.call(payroll)
    new(payroll).update_payroll
  end

  def initialize(payroll)
    @payroll = payroll
  end

  def update_payroll
    payroll_fields = PayrollCalculator.call(worker, period, @payroll)
    @payroll.update(**payroll_fields)

    if @payroll.save
      { success: true, payroll: @payroll }
    else
      { success: false, errors: @payroll.errors }
    end
  end

  private

  def period
    @payroll.period
  end

  def worker
    @payroll.worker
  end
end
