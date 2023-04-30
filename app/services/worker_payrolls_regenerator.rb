class WorkerPayrollsRegenerator
  def self.call(worker, initial_date, end_date)
    new(worker, initial_date, end_date).regenerate_payrolls!
  end

  def initialize(worker, initial_date, end_date)
    @worker = worker
    @initial_date = initial_date
    @end_date = end_date || Date.new(3000, 12, 31)
    @periods = @worker&.company&.periods
  end

  def regenerate_payrolls!
    return if @worker.nil?

    update_payrolls_in_date_range
    create_missing_payrolls
  end

  private


  def update_payrolls_in_date_range
    affected_periods = @worker.company.find_company_periods_between(@initial_date, @end_date)

    affected_payrolls = affected_periods.map(&:payrolls).flatten
    affected_payrolls.each(&:recalculate!)
  end

  def create_missing_payrolls
    periods_in_worker_range = @worker.company.find_company_periods_between(@initial_date, @end_date)
    periods_without_payroll = periods_in_worker_range.left_outer_joins(:payrolls)
                                                     .where('payrolls.worker_id != ? OR payrolls.id IS NULL', @worker.id)

    periods_without_payroll.each do |period|
      PayrollCreator.call(@worker, period)
    end
  end
end
