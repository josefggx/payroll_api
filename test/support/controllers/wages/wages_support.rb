module WagesSupport
  def wage_params
    {
      wage: {
        base_salary: '2600000',
        transport_subsidy: true,
        initial_date: '2023-04-20'
      }
    }
  end

  def wage_edited_params
    {
      wage: {
        base_salary: '3000000',
        transport_subsidy: true,
        initial_date: '2023-05-16'
      }
    }
  end

  def wage_invalid_params
    {
      wage: {
        base_salary: '',
        transport_subsidy: true,
        initial_date: '2024-01-20'
      }
    }
  end

  def wage_valid_keys
    %w[id base_salary transport_subsidy initial_date end_date contract_id] + wage_additional_keys
  end

  def wage_additional_keys
    %w[]
  end
end
