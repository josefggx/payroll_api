json.data do
  json.id @period.id
  json.company_id @period.company_id
  json.start_date @period.start_date
  json.end_date @period.end_date
  json.length "monthly"
  json.payrolls_number @period.payrolls_count || 0
  json.total_salaries @period.total_salaries || 0
  json.total_company_cost @period.total_company_cost || 0
  json.payrolls @period.payrolls do |payroll|
    json.payroll_id payroll.id
    json.worker_id payroll.worker.id
    json.worker_name payroll.worker.name
    json.base_salary payroll.base_salary
    json.worker_payment payroll.worker_payment
    json.total_company_cost payroll.total_company_cost
    json.additional_salary_income payroll.additional_salary_income
    json.non_salary_income payroll.non_salary_income
    json.deductions payroll.deductions
  end
end
