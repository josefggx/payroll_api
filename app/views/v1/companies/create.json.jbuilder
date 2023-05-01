json.data do
  json.partial! 'company', company: @company
  json.user_id @company.user_id
end
