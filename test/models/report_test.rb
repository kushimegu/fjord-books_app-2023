# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase

  test 'editable' do
    user = User.new
    report = Report.new(user: user)

    assert true, report.editable?(user)

    different_user = User.new
    refute false, report.editable?(different_user)
  end

  test 'created_on' do
    report = Report.new(created_at: '2024-08-30 17:17:06')
    date = Date.new(2024, 8, 30)

    assert_equal date, report.created_on
  end
end
