module PayrollsSupport
  def payroll_params
    {
      payroll: {
        period_id: periods(:period).id,
        worker_id: workers(:worker).id
      }
    }
  end

  def payroll_invalid_params
    {
      payroll: {
        period_id: periods(:period),
        worker_id: -1
      }
    }
  end

  def payroll_valid_keys
    %w[id period_id worker_id base_salary transport_subsidy additional_salary_income
       non_salary_income worker_healthcare worker_pension solidarity_fund
       subsistence_account deductions company_healthcare company_pension arl
       compensation_fund icbf sena severance interest premium vacation worker_payment
       total_company_cost worker_name period_start period_end_date] + payroll_additional_keys
  end

  def payroll_additional_keys
    []
  end
end
