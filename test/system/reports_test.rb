# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:alice_report)

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

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'Railsテストのプラクティスに苦戦'
    fill_in '内容', with: 'なかなか難しい'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text 'Railsテストのプラクティスに苦戦'
    assert_text 'alice@example.com'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first

    fill_in 'タイトル', with: 'テスト技法の再提出'
    fill_in '内容', with: '他の人の日報が役に立った'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'テスト技法の再提出'
    assert_text '他の人の日報が役に立った'
    assert_text 'alice@example.com'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました。'
  end
end
