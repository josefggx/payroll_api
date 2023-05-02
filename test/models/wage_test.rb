require 'test_helper'

class WageTest < ActiveSupport::TestCase
  include AssertColumnMatch

  def setup
    @wage = wages(:wage)
    @contract = contracts(:contract)
  end

  test 'database columns should match expected schema' do
    expected_columns = {
      id: [:uuid, false],
      contract_id: [:uuid, false],
      base_salary: [:decimal, false],
      transport_subsidy: [:boolean, false],
      initial_date: [:date, false],
      end_date: [:date, true],
      created_at: [:datetime, false],
      updated_at: [:datetime, false]
    }

    Wage.columns.each do |column|
      assert_column_match(column, expected_columns, Wage.name)
    end
  end

  test 'belongs_to :contract relation' do
    assert_equal @wage.contract, @contract, 'relation between wage and contract'
  end

  test 'has_one :companies through :contract relation' do
    assert_equal @wage.company, companies(:company), 'relation between wage and companies'
  end

  test 'has_one :worker through :contract relation' do
    assert_equal @wage.worker, workers(:worker), 'relation between wage and worker'
  end

  test 'has_many :periods through :worker relation' do
    assert_equal @wage.periods.count, 1, 'relation between wage and periods'
  end

  test 'has_many :payrolls through :periods relation' do
    assert_equal @wage.payrolls.count, 2, 'relation between wage and payrolls'
  end

  test 'should create a new wage with valid attributes' do
    assert_difference 'Wage.count', 1 do
      Wage.create(
        contract: @contract,
        base_salary: 1000.00,
        transport_subsidy: true,
        initial_date: Date.today
      )
    end
  end

  test 'wage should be invalid without a base_salary' do
    @wage.base_salary = nil

    assert_not @wage.valid?
    assert @wage.errors[:base_salary].present?, 'error without base_salary'
  end

  test 'wage should be invalid with a negative base_salary' do
    @wage.base_salary = -1000.00

    assert_not @wage.valid?
    assert @wage.errors[:base_salary].present?, 'error with negative base_salary'
  end

  test 'wage should be invalid without an initial_date' do
    @wage.initial_date = nil

    assert_not @wage.valid?
    assert @wage.errors[:initial_date].present?, 'error without initial_date'
  end

  test 'wage should be invalid if initial_date is not in contract dates' do
    @wage.initial_date = @wage.contract.initial_date - 1.day

    assert_not @wage.valid?
    assert @wage.errors[:initial_date].present?, 'error with initial_date not in contract dates'
  end

  test 'wage should be invalid if initial_date is before last wage initial_date' do
    last_wage = wages(:wage_two)
    last_wage.update(initial_date: Date.today - 1.month)
    @wage.initial_date = last_wage.initial_date - 1.day

    assert_not @wage.valid?
    assert @wage.errors[:initial_date].present?, 'error with initial_date before last wage initial_date'
  end

  test 'wage should be invalid if transport_subsidy is true and base_salary is low' do
    company = companies(:company)
    worker = Worker.create(name: 'Test Worker', id_number: '123456', company: company)
    contract = Contract.create(
      worker: worker,
      job_title: 'Software Developer',
      health_provider: 'Sura',
      term: 'fixed',
      risk_type: 'risk_1',
      initial_date: Date.today,
      end_date: Date.today + 1.year
    )
    wage = Wage.create(
      contract: contract,
      base_salary: 1_300_000,
      transport_subsidy: false,
      initial_date: Date.today
    )

    assert_not wage.valid?, 'wage should be invalid'
    assert wage.errors[:transport_subsidy].present?, 'error without transport_subsidy'
  end
end
