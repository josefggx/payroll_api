class RegenerateWorkerPayrollsJob < ApplicationJob
  queue_as :default

  def perform(worker, initial_date, end_date = nil)
    WorkerPayrollsRegenerator.call(worker, initial_date, end_date)
  end
end
