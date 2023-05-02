require 'test_helper'
require_relative '../../app/services/payroll_updater'

class PayrollUpdaterTest < ActiveSupport::TestCase
  setup do
    @worker = workers(:worker)
    @period = periods(:another_period)
    @payroll = payrolls(:payroll)
  end

  test "updates a payroll successfully" do
    result = PayrollUpdater.call(@payroll)

    assert result[:success]
    assert result[:payroll].persisted?
    assert_equal @worker, result[:payroll].worker
    assert_equal @period, result[:payroll].period
  end
end
