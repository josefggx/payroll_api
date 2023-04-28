# frozen_string_literal: true

module PayrollHelper
  CONTRACT_TERMS = %w[indefinite fixed].freeze
  PERIOD_DAYS = 30
  MINIMUM_WAGE = 1_160_000
  TRANSPORT_SUBSIDY = 140_606

  WORKER_HEALTHCARE = 0.04
  WORKER_PENSION = 0.04
  SOLIDARITY_FUND = 0.01
  SUBSISTENCE_PERCENTAGE = {
    level1: 0.002,
    level2: 0.004,
    level3: 0.006,
    level4: 0.008,
    level5: 0.01
  }.freeze

  COMPANY_HEALTHCARE = 0.085
  COMPANY_PENSION = 0.12
  RISK_TYPES = {
    'risk_1' => 0.00522,
    'risk_2' => 0.01044,
    'risk_3' => 0.02436,
    'risk_4' => 0.04350,
    'risk_5' => 0.06960
  }.freeze

  COMPENSATION_FUND = 0.04
  ICBF = 0.03
  SENA = 0.02

  PREMIUM = 1.0 / 12.0
  INTEREST = 0.12
  SEVERANCE = 1.0 / 12.0
  VACATIONS = 1.0 / 24.0
end
