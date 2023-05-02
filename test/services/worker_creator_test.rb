require 'test_helper'
require_relative '../../app/services/worker_creator'

class WorkerCreatorTest < ActiveSupport::TestCase
  include WorkerCreatorSupport

  test "creates a worker, with it's contract and wage" do
    result = WorkerCreator.call(worker_creation_params)

    assert result[:success]
    assert result[:worker].valid?
    assert_equal 'Luigi', result[:worker].name
    assert_equal companies(:company).id, result[:worker].company_id
    assert_equal 'Developer', result[:worker].contract.job_title
    assert_equal 1_300_000, result[:worker].contract.wages.last.base_salary
  end

  test 'returns errors when worker is not valid' do
    result = WorkerCreator.call(worker_creation_invalid_worker_params)

    refute result[:success]
    assert_equal 3, result[:errors].size
    assert result[:errors].first.has_key?(:name)
  end

  test 'returns errors when contract is not valid' do
    result = WorkerCreator.call(worker_creation_invalid_contract_params)

    refute result[:success]
    assert_equal 3, result[:errors].size
    assert result[:errors].second.has_key?(:job_title)
  end

  test 'returns errors when wage is not valid' do
    result = WorkerCreator.call(worker_creation_invalid_wage_params)

    refute result[:success]
    assert_equal 3, result[:errors].size
    assert result[:errors].third.has_key?(:transport_subsidy)
  end
end
