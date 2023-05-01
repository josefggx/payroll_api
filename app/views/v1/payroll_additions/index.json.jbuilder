json.data @payroll_additions do |payroll_addition|
  json.merge! payroll_addition.attributes.except('created_at', 'updated_at')
  json.period_id payroll_addition.period.id
  json.period_start_date payroll_addition.period.start_date
  json.period_end_date payroll_addition.period.end_date
end
