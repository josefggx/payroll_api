module StringValidations
  extend ActiveSupport::Concern

  def regex_valid_email
    /\A(?![<>$])[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  end

  def regex_valid_name
    /\A(?![<>$])[0-9a-zA-Z√ë±°©≠≥∫ºÅâçìö&-_ ]*\z/
  end

  def regex_valid_year
    /\A\d{1,4}\z/
  end

  def regex_valid_month
    /^(0?[1-9]|1[0-2])$/
  end

  def regex_insecure_string
    /[<>$]/
  end
end
