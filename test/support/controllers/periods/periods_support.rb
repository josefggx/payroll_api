module PeriodsSupport
  def period_params
    {
      period: {
        year: '2023',
        month: '05'
      }
    }
  end

  def period_edited_params
    {
      period: {
        year: '2023',
        month: '06'
      }
    }
  end

  def period_invalid_params
    {
      period: {
        year: '',
        month: '13'
      }
    }
  end

  def period_valid_keys
    %w[id company_id start_date end_date] + period_additional_keys
  end

  def period_additional_keys
    %w[length payrolls_number total_salaries total_company_cost payrolls]
  end
end
