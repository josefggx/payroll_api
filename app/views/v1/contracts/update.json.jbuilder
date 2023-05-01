json.data do
  json.id @contract.id
  json.worker_name @contract.worker&.name
  json.worker_id @contract.worker&.id
  json.job_title @contract.job_title
  json.initial_date @contract.initial_date
  json.end_date @contract.end_date
  json.contract_term @contract.term
  json.health_provider @contract.health_provider
  json.risk_type @contract.risk_type
end
