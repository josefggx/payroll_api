json.data @contracts do |contract|
  json.id contract.id
  json.worker_name contract.worker&.name
  json.job_title contract.job_title
  json.initial_date contract.initial_date
  json.end_date contract.end_date
  json.contract_term contract.term
  json.health_provider contract.health_provider
  json.risk_type contract.risk_type
  json.base_salary contract.wages&.last&.base_salary
  json.transport_subsidy contract.wages&.last&.transport_subsidy
end


