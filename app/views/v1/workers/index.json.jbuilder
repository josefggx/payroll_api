json.data @workers do |worker|
  json.id worker.id
  json.name worker.name
  json.id_number worker.id_number
  json.job_title worker.contract&.job_title
  json.base_salary worker.wages&.last&.base_salary
  json.initial_date worker.wages&.last&.initial_date
  json.end_date worker.wages&.last&.end_date
end
