require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include AssertColumnMatch

  def setup
    @user = users(:valid_user)
  end

  test 'user database columns should match expected schema' do
    expected_columns = {
      id: [:uuid, false],
      email: [:string, false],
      password_digest: [:string, false],
      created_at: [:datetime, false],
      updated_at: [:datetime, false]
    }

    User.columns.each do |column|
      assert_column_match(column, expected_columns, User.name)
    end
  end

  test 'has_many :companies relation' do
    assert_equal 1, @user.companies.size, 'relation between user and companies'
  end

  test 'should create a new user with valid attributes' do
    assert_difference 'User.count', 1 do
      User.create(email: 'test@example.com', password: 'password', password_confirmation: 'password')
    end
  end

  test 'user should be invalid without an email' do
    @user.email = nil

    assert_not @user.valid?
    assert @user.errors[:email].present?, 'error without email'
  end

  test 'user should be invalid with an invalid email format' do
    @user.email = 'invalid_email'

    assert_not @user.valid?
    assert @user.errors[:email].present?, 'error with invalid email'
  end

  test 'user should be invalid with a password shorter than 6 characters' do
    @user.password = 'short'

    assert_not @user.valid?
    assert @user.errors[:password].present?, 'error with password too short'
  end

  test 'user should be invalid without a password' do
    @user.password = nil

    assert_not @user.valid?
    assert @user.errors[:password].present?, 'error without password'
  end
end
