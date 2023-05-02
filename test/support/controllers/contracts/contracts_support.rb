module ContractsSupport
  def contract_params
    {
      contract: {
        job_title: 'Abogado',
        term: 'fixed',
        risk_type: 'risk_1',
        health_provider: 'EPS Sura',
        initial_date: '2023-01-16',
        end_date: '2023-06-27'
      }
    }
  end

  def contract_edited_params
    {
      contract: {
        job_title: 'Developer',
        term: 'fixed',
        risk_type: 'risk_1',
        health_provider: 'EPS Sura',
        initial_date: '2023-01-16',
        end_date: '2023-06-27'
      }
    }
  end

  def contract_invalid_params
    {
      contract: {
        job_title: 'H',
        term: 'fixed',
        risk_type: 'risk_1',
        health_provider: 'EPS Sura',
        initial_date: '2023-01-16',
        end_date: ''
      }
    }
  end

  def contract_valid_keys
    %w[id worker_id job_title initial_date end_date contract_term
       health_provider risk_type wages] + contract_additional_keys
  end

  def contract_additional_keys
    %w[worker_name]
  end
end
