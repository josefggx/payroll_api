module WorkersSupport
  def worker_params
    {
      worker: {
        name: 'John Doe',
        id_number: 12356789,
        company_id: companies(:company),
        job_title: 'Software Engineer',
        term: 'fixed',
        risk_type: 'risk_1',
        health_provider: 'Sura',
        base_salary: 1_300_000,
        transport_subsidy: true,
        initial_date: '2023-01-01',
        end_date: '2023-12-01'
      }
    }
  end

  def worker_edited_params
    {
      worker: {
        name: 'John Doe',
        id_number: 123456789,
        company_id: companies(:company),
        job_title: 'Software Engineer',
        term: 'fixed',
        risk_type: 'risk_1',
        health_provider: 'Sura',
        base_salary: 1_300_000,
        transport_subsidy: true,
        initial_date: '2023-01-01',
        end_date: '2023-12-01'
      }
    }
  end

  def worker_invalid_params
    {
      worker: {
        name: '',
        id_number: 123456789,
        company_id: companies(:company),
        job_title: 'Software Engineer',
        term: 'fixed',
        risk_type: 'risk_1',
        health_provider: 'Sura',
        base_salary: 1_300_000,
        transport_subsidy: true,
        initial_date: '2023-01-01',
        end_date: '2023-12-01'
      },
      company_id: companies(:company)
    }
  end

  def worker_valid_keys
    %w[id name id_number company_id ] + worker_additional_keys
  end

  def worker_additional_keys
    %w[company_name company_id job_title base_salary transport_subsidy contract_id
       initial_date end_date contract_term health_provider risk_type]
  end
end

