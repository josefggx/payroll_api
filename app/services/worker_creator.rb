class WorkerCreator
  def self.call(params)
    new(params).create_worker
  end

  def initialize(params)
    @params = params
  end

  def create_worker
    worker = Worker.new(worker_params)
    contract = worker.build_contract(contract_params)
    wage = contract.wages.build(wage_params)

    if worker.save && contract.save && wage.save
      { success: true, worker: worker.reload }
    else
      errors = [worker.errors, contract.errors, wage.errors].compact

      { success: false, errors: errors }
    end
  end

  def worker_params
    @params.slice(:name, :id_number, :company_id)
  end

  def contract_params
    @params.slice(:job_title, :term, :contract_category, :risk_type, :health_provider, :initial_date, :end_date)
  end

  def wage_params
    @params.slice(:base_salary, :transport_subsidy, :initial_date, :end_date)
  end
end
