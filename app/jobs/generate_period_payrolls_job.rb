class GeneratePeriodPayrollsJob < ApplicationJob
  queue_as :default

  def perform(period)
    PeriodPayrollsGenerator.call(period)
  end
end
