class PeriodsQuery
  def initialize(company)
    @company = company
  end

  def periods_with_payrolls_totals
    @company.periods
            .select(
              'periods.*',
              'COUNT(payrolls.id) AS payrolls_count',
              'SUM(payrolls.base_salary) AS total_salaries',
              'SUM(payrolls.total_company_cost) AS total_company_cost'
            )
            .left_outer_joins(:payrolls)
            .group('periods.id')
            .order('end_date DESC')
  end

  def period_with_payrolls_and_worker_info(period_id)
    @company.periods
            .select(
              'periods.*',
              '(SELECT COUNT(payrolls.id) FROM payrolls WHERE payrolls.period_id = periods.id) AS payrolls_count',
              '(SELECT SUM(payrolls.base_salary) FROM payrolls WHERE payrolls.period_id = periods.id) AS total_salaries',
              '(SELECT SUM(payrolls.total_company_cost) FROM payrolls WHERE payrolls.period_id = periods.id) AS total_company_cost',
              'payrolls.id AS payroll_id',
              'workers.id AS worker_id',
              'workers.name AS worker_name',
              'payrolls.base_salary',
              'payrolls.additional_salary_income',
              'payrolls.non_salary_income',
              'payrolls.deductions',
              'payrolls.worker_payment',
              'payrolls.total_company_cost'
            )
            .joins(payrolls: :worker)
            .includes(payrolls: :worker)
            .where(periods: { id: period_id })
            .order('workers.name ASC')
            .first
  end
end
