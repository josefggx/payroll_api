json.data do
  json.id @period.id
  json.company_id @period.company_id
  json.start_date @period.start_date
  json.end_date @period.end_date
  json.length "monthly"
end
