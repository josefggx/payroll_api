require 'test_helper'

class WorkerTest < ActiveSupport::TestCase
  include AssertColumnMatch

  def setup
    @company = companies(:company)
    @worker = workers(:worker)
  end

  test 'worker database columns should match expected schema' do
    expected_columns = {
      id: [:uuid, false],
      name: [:string, false],
      id_number: [:integer, false],
      company_id: [:uuid, false],
      created_at: [:datetime, false],
      updated_at: [:datetime, false]
    }

    Worker.columns.each do |column|
      assert_column_match(column, expected_columns, Worker.name)
    end
  end

  test 'belongs_to :companies relation' do
    assert_not_nil @worker.company, 'relation between worker and companies'
  end

  test 'has_one :contract relation' do
    assert_not_nil @worker.contract, 'relation between worker and contract'
  end

  test 'has_many :wages through :contract relation' do
    assert_not_nil @worker.wages, 'relation between worker and wages'
  end

  test 'has_many :payrolls relation' do
    assert_not_nil @worker.payrolls, 'relation between worker and payrolls'
  end

  test 'has_many :periods through :payrolls relation' do
    assert_not_nil @worker.periods, 'relation between worker and periods'
  end

  test 'has_many :payroll_additions through :payrolls relation' do
    assert_not_nil @worker.payroll_additions, 'relation between worker and payroll additions'
  end

  test 'should be valid' do
    assert @worker.valid?, 'Worker should be valid'
  end

  test 'name should be present' do
    @worker.name = '     '
    assert_not @worker.valid?, 'Name should be present'
  end

  test 'id_number should be present' do
    @worker.id_number = nil
    assert_not @worker.valid?, 'ID number should be present'
  end

  test 'id_number should be greater than 0' do
    @worker.id_number = -1
    assert_not @worker.valid?, 'ID number should be greater than 0'
  end

  test 'id_number should be unique' do
    duplicate_worker = @worker.dup
    duplicate_worker.company_id = @worker.company_id
    @worker.save
    assert_not duplicate_worker.valid?, 'ID number should be unique'
  end

  test 'id_number should have a length between 6 and 10 characters' do
    @worker.id_number = 12345
    assert_not @worker.valid?, 'ID number should have a length between 6 and 10 characters'

    @worker.id_number = 12345678901456
    assert_not @worker.valid?, 'ID number should have a length between 6 and 10 characters'

    @worker.id_number = 1234567
    assert @worker.valid?, 'ID number should have a length between 6 and 10 characters'

    @worker.id_number = 123956789
    assert @worker.valid?, 'ID number should have a length between 6 and 10 characters'

    @worker.id_number = 1234567890
    assert @worker.valid?, 'ID number should have a length between 6 and 10 characters'
  end

  test 'name should have a length between 3 and 30 characters' do
    @worker.name = 'a' * 2
    assert_not @worker.valid?, 'Name should have a length between 3 and 30 characters'

    @worker.name = 'a' * 31
    assert_not @worker.valid?, 'Name should have a length between 3 and 30 characters'

    @worker.name = 'a' * 3
    assert @worker.valid?, 'Name should have a length between 3 and 30 characters'

    @worker.name = 'a' * 30
    assert @worker.valid?, 'Name should have a length between 3 and 30 characters'
  end

  test 'name should have a valid format' do
    @worker.name = '!nvalid @ari$'
    assert_not @worker.valid?, 'Name should have a valid format'

    @worker.name = 'Mario Bros'
    assert @worker.valid?, 'Name should have a valid format'
  end
end
