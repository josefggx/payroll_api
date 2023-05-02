module AuthHelper
  include JsonWebToken

  def auth_headers(user)
    token = generate_token(user)
    { 'Authorization': "Bearer #{token}" }
  end

  def generate_token(user)
    jwt_encode({ user_id: user.id} )
  end
end
