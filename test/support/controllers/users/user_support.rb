module UserSupport
  def user_params
    {
      user: {
        email: 'bowser@gmail.com',
        password: 'bowser_password'
      }
    }
  end

  def user_edited_params
    {
      user: {
        email: 'bowsercode@gmail.com',
        password: 'bowser_password'
      }
    }
  end

  def user_invalid_params
    {
      user: {
        email: '',
        password: 'bowser_password'
      }
    }
  end

  def user_valid_keys
    %w[id email]
  end
end
