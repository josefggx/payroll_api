# frozen_string_literal: true

module PayrollHelper
  RISK_TYPES = {
    'risk_1' => 0.00522,
    'risk_2' => 0.01044,
    'risk_3' => 0.02436,
    'risk_4' => 0.04350,
    'risk_5' => 0.06960
  }.freeze
  CONTRACT_TERMS = %w[indefinite fixed].freeze
  MINIMUM_WAGE = 908_526
  PENSION_EMPLOYEE_PERCENTAGE = 0.04
  PENSION_EMPLOYER_PERCENTAGE = 0.12
  HEALTH_EMPLOYEE_PERCENTAGE = 0.04
  HEALTH_EMPLOYER_PERCENTAGE = 0.085
end
