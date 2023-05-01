json.data @payrolls do |payroll|
  json.extract! payroll, :id, :period_id
  json.period_start payroll.period.start_date
  json.period_end_date payroll.period.end_date
  json.worker_name payroll.worker.name
  json.merge! payroll.attributes.except('created_at', 'updated_at')
end
