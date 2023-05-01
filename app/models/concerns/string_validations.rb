module StringValidations
  extend ActiveSupport::Concern

  def regex_valid_email
    /\A(?![<>\$])[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  end

  def regex_valid_name
    /\A(?![<>\$])[0-9a-zA-Z√ë√±√°√©√≠√≥√∫√º√Å√â√ç√ì√ö&-_ ]*\z/
  end

  def regex_insecure_string
    /[<>\$]/
  end
end
