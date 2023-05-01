json.data @periods do |period|
  json.id period.id
  json.company_id period.company_id
  json.start_date period.start_date
  json.end_date period.end_date
  json.length "monthly"
  json.payrolls_number period.payrolls_count || 0
  json.total_salaries period.total_salaries || 0
  json.total_company_cost period.total_company_cost || 0
end
