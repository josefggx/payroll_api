require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  include AssertColumnMatch

  def setup
    @company = companies(:company)
  end

  test 'companies database columns should match expected schema' do
    expected_columns = {
      id: [:uuid, false],
      name: [:string, false],
      nit: [:integer, false],
      user_id: [:uuid, false],
      created_at: [:datetime, false],
      updated_at: [:datetime, false]
    }

    Company.columns.each do |column|
      assert_column_match(column, expected_columns, Company.name)
    end
  end

  test 'belongs_to :user relation' do
    assert_not_nil @company.user, 'relation between companies and user'
  end

  test 'has_many :workers relation' do
    assert_not_nil @company.workers, 'relation between companies and workers'
  end

  test 'has_many :contracts relation' do
    assert_not_nil @company.contracts, 'relation between companies and contracts'
  end

  test 'has_many :wages relation' do
    assert_not_nil @company.wages, 'relation between companies and wages'
  end

  test 'has_many :periods relation' do
    assert_not_nil @company.periods, 'relation between companies and periods'
  end

  test 'has_many :payrolls relation' do
    assert_not_nil @company.payrolls, 'relation between companies and payrolls'
  end

  test 'has_many :payroll_additions relation' do
    assert_not_nil @company.payroll_additions, 'relation between companies and payroll additions'
  end

  test 'user_id index should exists in companies table' do
    indexes = ::ActiveRecord::Base.connection.indexes(Company.table_name)
    matched_index = indexes.detect { |each| each.columns == ['user_id'] }

    assert_equal true, matched_index.present?, 'user_id index exist in companies table'
  end

  test 'should create a new companies with valid attributes' do
    assert_difference 'Company.count', 1 do
      Company.create(name: 'Test Company', nit: 123456789, user_id: users(:valid_user).id)
    end
  end

  test 'companies should be invalid without a name' do
    @company.name = nil

    assert_not @company.valid?
    assert @company.errors[:name].present?, 'error without name'
  end

  test 'companies should be invalid with a name shorter than 3 characters' do
    @company.name = 'a'

    assert_not @company.valid?
    assert @company.errors[:name].present?, 'error with name too short'
  end

  test 'companies should be invalid with a name longer than 30 characters' do
    @company.name = 'a' * 31

    assert_not @company.valid?
    assert @company.errors[:name].present?, 'error with name too long'
  end

  test 'companies should have a valid name format' do
    @company.name = '1234!@56'

    assert_not @company.valid?
    assert @company.errors[:name].present?, 'error with invalid name format'
  end

  test 'companies should have a name between 3 and 30 characters' do
    @company.name = 'aa'

    assert_not @company.valid?
    assert @company.errors[:name].present?, 'error with name too short'

    @company.name = 'a' * 31

    assert_not @company.valid?
    assert @company.errors[:name].present?, 'error with name too long'
  end

  test 'companies should be invalid without a nit' do
    @company.nit = nil

    assert_not @company.valid?
    assert @company.errors[:nit].present?, 'error without nit'
  end

  test 'companies should be invalid with a nit shorter than 9 characters' do
    @company.nit = 12345678

    assert_not @company.valid?
    assert @company.errors[:nit].present?, 'error with nit too short'
  end

  test 'companies should be invalid with a nit longer than 9 characters' do
    @company.nit = 123456789034

    assert_not @company.valid?
    assert @company.errors[:nit].present?, 'error with nit too long'
  end

  test 'companies should have a unique nit' do
    company_with_same_nit = @company.dup
    company_with_same_nit.nit = @company.nit

    assert_not company_with_same_nit.valid?
    assert company_with_same_nit.errors[:nit].present?, 'error with nit already taken'
  end

  test 'companies should be invalid without a user' do
    @company.user = nil

    assert_not @company.valid?
    assert @company.errors[:user].present?, 'error without user'
  end
end
