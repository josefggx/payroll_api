class PeriodPayrollsGenerator
  def self.call(period)
    new(period).generate_payrolls_for_period
  end

  def initialize(period)
    @period = period
  end

  def generate_payrolls_for_period
    workers = find_workers_for_period

    return if workers.empty?

    workers.each do |worker|
      PayrollCreator.call(worker, @period)
    end
  end

  private

  def find_workers_for_period
    @period.company
           .workers
           .joins(:contract)
           .where('(contracts.initial_date <= ? AND contracts.end_date >= ?) OR
                                  (contracts.initial_date >= ? AND contracts.initial_date <= ?) OR
                                  (contracts.end_date IS NULL AND contracts.initial_date <= ?)',
                  @period.end_date, @period.start_date, @period.start_date, @period.end_date, @period.end_date)
  end
end
