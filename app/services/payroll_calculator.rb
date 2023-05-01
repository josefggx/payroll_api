class PayrollCalculator
  include PayrollHelper

  def self.call(worker, period, payroll = nil)
    new(worker, period, payroll).calculate_payroll
  end

  def initialize(worker, period, payroll = nil)
    @worker = worker
    @period = period
    @payroll = payroll
    @base_salary = 0
    @transport_subsidy = 0
  end

  def calculate_payroll
    calculate_average_base_salary

    additional_salary_income = calculate_extra_salary_income
    non_salary_income = calculate_non_salary_income

    salary_for_ss = @base_salary + additional_salary_income
    salary_for_social_benefits = salary_for_ss + @transport_subsidy

    total_worker_income = salary_for_social_benefits + non_salary_income

    worker_healthcare = salary_for_ss * WORKER_HEALTHCARE
    worker_pension = salary_for_ss * WORKER_PENSION
    solidarity_fund = salary_for_ss >= (MINIMUM_WAGE * 4) ? (salary_for_ss * SOLIDARITY_FUND) : 0
    subsistence_account = calculate_subsistence_acc(salary_for_ss)
    deductions = calculate_deductions

    total_retention_deductions = worker_healthcare + worker_pension + solidarity_fund + subsistence_account + deductions

    company_healthcare = salary_for_ss >= (MINIMUM_WAGE * 10) ? (salary_for_ss * COMPANY_HEALTHCARE) : 0
    company_pension = salary_for_ss * COMPANY_PENSION
    arl = salary_for_ss * RISK_TYPES[@worker.contract.risk_type]

    total_social_security = company_healthcare + company_pension + arl

    compensation_fund = salary_for_ss * COMPENSATION_FUND
    icbf = salary_for_ss >= (MINIMUM_WAGE * 10) ? (salary_for_ss * ICBF) : 0
    sena = salary_for_ss >= (MINIMUM_WAGE * 10) ? (salary_for_ss * SENA) : 0

    total_parafiscal_charges = compensation_fund + icbf + sena

    severance = salary_for_social_benefits * SEVERANCE
    interest = severance * INTEREST
    premium = salary_for_social_benefits * PREMIUM
    vacation = salary_for_ss * VACATIONS

    total_social_benefits = severance + interest + premium + vacation

    worker_payment = total_worker_income - total_retention_deductions
    total_company_cost = total_worker_income + total_social_security + total_parafiscal_charges + total_social_benefits

    {
      base_salary: @base_salary,
      transport_subsidy: @transport_subsidy,
      additional_salary_income:,
      non_salary_income:,

      worker_healthcare:,
      worker_pension:,
      solidarity_fund:,
      subsistence_account:,
      deductions:,

      company_healthcare:,
      company_pension:,
      arl:,

      compensation_fund:,
      icbf:,
      sena:,

      severance:,
      interest:,
      premium:,
      vacation:,

      worker_payment:,
      total_company_cost:
    }
  end

  private

  def calculate_average_base_salary
    wages = @worker.find_worker_wages_for_period(@period)
    days_in_month = Time.days_in_month(@period.start_date.month, @period.start_date.year)

    wages.each do |wage|
      days_worked = calculate_days_worked(wages, days_in_month, wage)

      wage_base_salary = calculate_base_salary(wage.base_salary, days_worked, days_in_month)

      @base_salary += wage_base_salary

      wage_transport_subsidy = calculate_transport_subsidy(wage.transport_subsidy, days_worked, days_in_month)
      @transport_subsidy += wage_transport_subsidy
    end
  end

  def calculate_days_worked(wages, days_in_month, wage)
    days_worked = [wage.end_date, @period.end_date].compact.min -
                  [wage.initial_date, @period.start_date].compact.max + 1

    days_worked += 2 if days_in_month == 28 && (wage == wages.last) && wages.count > 1
    days_worked -= 1 if days_in_month == 31 && (wage == wages.last)

    days_worked
  end

  def calculate_base_salary(base_salary, days_worked, days_in_month)
    worked_full_month = days_worked == days_in_month
    worked_full_month ? base_salary : (base_salary * days_worked / PERIOD_DAYS)
  end

  def calculate_transport_subsidy(transport_subsidy, days_worked, days_in_month)
    return 0 unless transport_subsidy

    worked_full_month = days_worked == days_in_month
    worked_full_month ? TRANSPORT_SUBSIDY : (TRANSPORT_SUBSIDY * days_worked / PERIOD_DAYS)
  end

  def calculate_subsistence_acc(base_salary_for_ss)
    return 0 if base_salary_for_ss < MINIMUM_WAGE * 16

    percentage = case base_salary_for_ss
                 when (MINIMUM_WAGE * 17)...(MINIMUM_WAGE * 18)
                   SUBSISTENCE_PERCENTAGE[:level2]
                 when (MINIMUM_WAGE * 18)...(MINIMUM_WAGE * 19)
                   SUBSISTENCE_PERCENTAGE[:level3]
                 when (MINIMUM_WAGE * 19)...(MINIMUM_WAGE * 20)
                   SUBSISTENCE_PERCENTAGE[:level4]
                 else
                   SUBSISTENCE_PERCENTAGE[:level5]
                 end

    base_salary_for_ss * percentage
  end

  def calculate_extra_salary_income
    deductions = @payroll&.payroll_additions&.salary_income
    deductions&.sum(:amount) || 0
  end

  def calculate_non_salary_income
    deductions = @payroll&.payroll_additions&.non_salary_income
    deductions&.sum(:amount) || 0
  end

  def calculate_deductions
    deductions = @payroll&.payroll_additions&.deductions
    deductions&.sum(:amount) || 0
  end
end
