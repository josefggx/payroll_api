require "test_helper"

class ContractTest < ActiveSupport::TestCase
  include AssertColumnMatch

  def setup
    @contract = contracts(:contract)
    @worker = workers(:worker)
  end

  test 'database columns should match expected schema' do
    expected_columns = {
      id: [:uuid, false],
      worker_id: [:uuid, false],
      job_title: [:string, false],
      health_provider: [:string, false],
      term: [:enum, false],
      risk_type: [:enum, false],
      initial_date: [:date, false],
      end_date: [:date, true],
      created_at: [:datetime, false],
      updated_at: [:datetime, false]
    }

    Contract.columns.each do |column|
      assert_column_match(column, expected_columns, Contract.name)
    end
  end

  test 'belongs_to :worker relation' do
    assert_equal @contract.worker, @worker, 'relation between contract and worker'
  end

  test 'has_one :companies through :worker relation' do
    assert_equal @contract.company, companies(:company), 'relation between contract and companies'
  end

  test 'has_many :wages relation' do
    assert_equal @contract.wages.count, 2, 'relation between contract and wages'
  end

  test 'should create a new contract with valid attributes' do
    assert_difference 'Contract.count', 1 do
      worker = Worker.create(name: 'worker', id_number: '13324242', company_id: companies(:company).id)
      Contract.create(
        worker: worker,
        job_title: 'Software Developer',
        health_provider: 'Sura',
        term: 'fixed',
        risk_type: 'risk_1',
        initial_date: Date.today,
        end_date: Date.today + 1.year
      )
    end
  end

  test 'contract should be invalid without a worker' do
    @contract.worker = nil

    assert_not @contract.valid?
    assert @contract.errors[:worker].present?, 'error without worker'
  end

  test 'contract should be invalid without a job_title' do
    @contract.job_title = nil

    assert_not @contract.valid?
    assert @contract.errors[:job_title].present?, 'error without job_title'
  end

  test 'contract should be invalid without a health_provider' do
    @contract.health_provider = nil

    assert_not @contract.valid?
    assert @contract.errors[:health_provider].present?, 'error without health_provider'
  end

  test 'contract should be invalid without a term' do
    @contract.term = nil

    assert_not @contract.valid?
    assert @contract.errors[:term].present?, 'error without term'
  end

  test 'contract should be invalid with an invalid term' do
    @contract.term = 'invalid_term'

    assert_not @contract.valid?
    assert @contract.errors[:term].present?, 'error with invalid term'
  end

  test 'contract should be invalid without a risk_type' do
    @contract.risk_type = nil

    assert_not @contract.valid?
    assert @contract.errors[:risk_type].present?, 'error without risk_type'
  end

  test 'contract should be invalid with an invalid risk_type' do
    @contract.risk_type = 'invalid_risk_type'

    assert_not @contract.valid?
    assert @contract.errors[:risk_type].present?, 'error with invalid risk_type'
  end
end
