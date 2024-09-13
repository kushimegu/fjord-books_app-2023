# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'editable' do
    correct_user = User.new
    report = Report.new(user: correct_user)

    assert true, report.editable?(correct_user)

    different_user = User.new

    assert_not report.editable?(different_user)
  end

  test 'created_on' do
    report = Report.new(created_at: Time.zone.parse('2024-08-30'))
    date = Date.new(2024, 8, 30)

    assert_equal date, report.created_on
  end

  test 'save_mentions' do
    alice_mentioned_report = reports(:alice_report)
    user = users(:alice)
    mentioning_report = user.reports.create!(title: '参考URL', content: "http://localhost:3000/reports/#{alice_mentioned_report.id}")

    assert_includes mentioning_report.mentioning_reports, alice_mentioned_report
    assert_includes alice_mentioned_report.mentioned_reports, mentioning_report

    bob_mentioned_report = reports(:bob_report)
    mentioning_report.update(content: "http://localhost:3000/reports/#{bob_mentioned_report.id}")

    assert_includes mentioning_report.mentioning_reports, bob_mentioned_report
    assert_includes bob_mentioned_report.mentioned_reports, mentioning_report
    assert_not_includes mentioning_report.reload.mentioning_reports, alice_mentioned_report

    mentioning_report.destroy

    assert_not_includes bob_mentioned_report.mentioned_reports, mentioning_report
  end
end
