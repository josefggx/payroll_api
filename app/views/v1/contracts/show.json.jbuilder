json.id @contract.id
json.worker_name @contract.worker&.name
json.job_title @contract.job_title
json.initial_date @contract.initial_date
json.end_date @contract.end_date
json.contract_term @contract.term
json.health_provider @contract.health_provider
json.risk_type @contract.risk_type
json.wages @contract.wages do |wage|
  json.wage_id wage.id
  json.base_salary wage.base_salary
  json.transport_subsidy wage.transport_subsidy
  json.initial_date wage.initial_date
  json.end_date wage.end_date
end
