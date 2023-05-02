module CompaniesSupport
  def company_params
    {
      company:
        { name: 'New Company',
          nit: '127632986' }
    }
  end

  def company_edited_params
    {
      company:
        { name: 'Edited Company',
          nit: '423456780' }
    }
  end

  def company_invalid_params
    {
      company:
        { name: '',
          nit: '127890' }
    }
  end

  def company_valid_keys
    %w[id name nit user_id] + company_additional_keys
  end

  def company_additional_keys
    %w[user_email]
  end
end
