ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  module Minitest::Assertions
    def assert_subset(subset, superset, msg = nil)
      assert subset.all? { |element| superset.include?(element) },
             msg || "#{subset.inspect} is not a subset of #{superset.inspect}"
    end
  end

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here..
  Dir[Rails.root.join('test/support/**/*.rb')].each { |f| require f }
end

