json.data do
  json.extract! @payroll, :id, :period_id
  json.merge! @payroll.attributes.except('created_at', 'updated_at')
  json.worker_name @payroll.worker.name
  json.period_start @payroll.period.start_date
  json.period_end_date @payroll.period.end_date
end
