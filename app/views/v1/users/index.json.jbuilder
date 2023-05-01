json.data @users do |user|
  json.partial! 'user', user: user
end
