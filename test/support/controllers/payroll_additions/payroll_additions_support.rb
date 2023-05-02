module PayrollAdditionsSupport
  def payroll_addition_params
    {
      period: {
        year: '2023',
        month: '05'
      }
    }
  end

  def payroll_addition_edited_params
    {
      period: {
        year: '2023',
        month: '06'
      }
    }
  end

  def payroll_addition_invalid_params
    {
      period: {
        year: '',
        month: '13'
      }
    }
  end

  def payroll_addition_valid_keys
    %w[id company_id start_date end_date] + period_additional_keys
  end

  def payroll_addition_additional_keys
    %w[length payrolls_number total_salaries total_company_cost payrolls]
  end
end
