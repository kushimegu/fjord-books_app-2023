# frozen_string_literal: true

require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  setup do
    @rails_book = books(:rails)
    @git_book = books(:git)

    visit root_url

    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting the index' do
    visit books_url

    assert_selector 'h1', text: '本の一覧'
  end

  test 'should show book with comment' do
    visit book_url(@rails_book)

    assert_text 'パーフェクトRuby on Rails'
    assert_text '難しい'
    assert_text 'すがわらまさのり'

    assert_text '勉強になった'
    assert_text 'alice@example.com'
  end

  test 'should show book without comment' do
    visit book_url(@git_book)

    assert_text 'Git&GitHubの教本'
    assert_text 'とてもわかりやすい'
    assert_text '宇賀神みずき'

    assert_text 'コメントはまだありません'
  end

  test 'should create book' do
    visit books_url
    click_on '本の新規作成'

    fill_in 'タイトル', with: 'Ruby超入門'
    fill_in 'メモ', with: 'わかりやすい'
    fill_in '著者', with: '五十嵐邦明'
    click_on '登録する'

    assert_text '本が作成されました。'
    assert_text 'Ruby超入門'
    assert_text 'わかりやすい'
    assert_text '五十嵐邦明'
  end

  test 'should update Book' do
    visit book_url(@rails_book)
    click_on 'この本を編集'

    fill_in 'タイトル', with: 'Ruby入門'
    fill_in 'メモ', with: '名著です'
    fill_in '著者', with: '伊藤淳一'
    click_on '更新する'

    assert_text '本が更新されました。'
    assert_text 'Ruby入門'
    assert_text '名著です'
    assert_text '伊藤淳一'
  end

  test 'should destroy Book' do
    visit book_url(@rails_book)
    click_on 'この本を削除'

    assert_text '本が削除されました。'
    refute_text 'パーフェクトRuby on Rails'
    refute_text '難しい'
    refute_text 'すがわらまさのり'
  end
end
