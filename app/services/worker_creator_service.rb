class WorkerCreatorService
  def self.create_worker(params)
    worker = Worker.new(worker_params(params))
    contract = worker.build_contract(contract_params(params))
    wage = contract.wages.build(wage_params(params))

    if worker.save && contract.save && wage.save
      { worker: worker.reload }
    else
      { worker:, contract:, wage: }
    end
  end

  def self.worker_params(params)
    params.require(:worker).permit(:name, :id_number).merge(company_id: params[:company_id])
  end

  def self.contract_params(params)
    params.require(:worker)
          .permit(:job_title, :term, :contract_category, :risk_type, :health_provider, :initial_date, :end_date)
  end

  def self.wage_params(params)
    params.require(:worker).permit(:base_salary, :transport_subsidy, :initial_date, :end_date)
  end
end
