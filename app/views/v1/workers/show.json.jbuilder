json.id @worker.id
json.name @worker.name
json.id_number @worker.id_number
json.company_id @worker.company&.id
json.company_name @worker.company&.name
json.job_title @worker.contract&.job_title
json.contract_category @worker.contract&.contract_category
json.term @worker.contract&.term
json.risk_type @worker.contract&.risk_type
json.health_provider @worker.contract&.health_provider
json.base_salary @worker.wages&.last&.base_salary
json.transport_subsidy @worker.wages&.last&.transport_subsidy
json.initial_date @worker.wages&.last&.initial_date
json.end_date @worker.wages&.last&.end_date
