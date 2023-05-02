module WorkerCreatorSupport
  def worker_creation_params
    {
      name: "Luigi",
      id_number: "1234524",
      company_id: companies(:company).id,
      job_title: "Developer",
      term: "fixed",
      risk_type: "risk_1",
      health_provider: "Sura",
      initial_date: Date.today,
      end_date: Date.today + 1.year,
      base_salary: 1_300_000,
      transport_subsidy: true
    }
  end

  def worker_creation_invalid_worker_params
    {
      name: "",
      id_number: "1234524",
      company_id: companies(:company).id,
      job_title: "Developer",
      term: "fixed",
      risk_type: "risk_1",
      health_provider: "Sura",
      initial_date: Date.today,
      end_date: Date.today + 1.year,
      base_salary: 1_300_000,
      transport_subsidy: true
    }
  end

  def worker_creation_invalid_contract_params
    {
      name: "Luigi",
      id_number: "1234524",
      company_id: companies(:company).id,
      job_title: "",
      term: "fixed",
      risk_type: "risk_1",
      health_provider: "Sura",
      initial_date: Date.today,
      end_date: Date.today + 1.year,
      base_salary: 1_300_000,
      transport_subsidy: true
    }
  end

  def worker_creation_invalid_wage_params
    {
      name: "Luigi",
      id_number: "1234524",
      company_id: companies(:company).id,
      job_title: "Developer",
      term: "fixed",
      risk_type: "risk_1",
      health_provider: "Sura",
      initial_date: Date.today,
      end_date: Date.today + 1.year,
      base_salary: 1_300_000
    }
  end
end

