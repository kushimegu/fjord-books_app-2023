# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @mentioned_report = reports(:alice_report)
    @alice_mentioning_report = reports(:alice_second_report)
    @bob_mentioning_report = reports(:bob_report)

    visit root_url
    assert_css 'h2', text: 'ログイン'
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting the index' do
    visit reports_url

    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should show mentioned report with comment' do
    visit report_url(@mentioned_report)

    assert_text '初めまして'
    assert_text 'よろしくお願いします'
    assert_text 'alice@example.com'

    assert_text '初めまして'
    assert_text 'bob@example.com'

    assert_text 'こんにちは'
    assert_text 'carol'
  end

  test 'should show mentioning report without comment' do
    visit report_url(@bob_mentioning_report)

    assert_text '初めまして'
    assert_text 'aliceの日報のURL'
    assert_text 'bob@example.com'

    assert_text 'この日報に言及している日報はまだありません'

    assert_text 'コメントはまだありません'
  end

  test 'should create report without mention' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'Railsテストのプラクティスに苦戦'
    fill_in '内容', with: 'なかなか難しい'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text 'Railsテストのプラクティスに苦戦'
    assert_text 'なかなか難しい'
    assert_text 'alice@example.com'
  end

  test 'should create report with mention' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'Railsテスト'
    fill_in '内容', with: "参考にしたhttp://localhost:3000/reports/#{@mentioned_report.id}"
    click_on '登録する'

    assert_text 'Railsテスト'
    assert_text "参考にしたhttp://localhost:3000/reports/#{@mentioned_report.id}"

    visit report_url(@mentioned_report)
    assert_text 'Railsテスト'
  end

  test 'should update report without mention' do
    visit report_url(@mentioned_report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: 'テスト技法の再提出'
    fill_in '内容', with: '理解できた'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'テスト技法の再提出'
    assert_text '理解できた'
    assert_text 'alice@example.com'
  end

  test 'should update report with mention' do
    visit report_url(@mentioned_report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: '日報機能の再提出'
    fill_in '内容', with: "役に立ったhttp://localhost:3000/reports/#{@bob_mentioning_report.id}"
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text '日報機能の再提出'
    assert_text "役に立ったhttp://localhost:3000/reports/#{@bob_mentioning_report.id}"
    assert_text 'alice@example.com'

    visit report_url(@bob_mentioning_report)
    assert_text '日報機能の再提出'
    assert_text 'alice@example.com'
  end
  
  test 'should destroy report without mention' do
    visit report_url(@mentioned_report)
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
    refute_text '初めての日報'
    refute_text 'よろしくお願いします'
  end

  test 'should destroy report with mention' do
    visit report_url(@alice_mentioning_report)
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
    refute_text '2回目の日報'
    refute_text '過去の日報のURL'

    visit report_url(@mentioned_report)
    refute_text '2回目の日報'
  end
end
