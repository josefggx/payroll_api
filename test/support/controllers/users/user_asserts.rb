module UserAsserts
  def user_response_asserts
    user = User.find(response_data['id'])

    assert_equal user_valid_keys, response_data.keys
    assert_equal user.id, response_data['id']
    assert_equal user.email, response_data['email']
    assert_nil response_data['password_digest']
  end
end
