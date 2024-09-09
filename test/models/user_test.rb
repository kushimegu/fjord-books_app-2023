# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'name_or_email' do
    user = User.new(email: 'yamada@example.com', name: '')

    assert_equal 'yamada@example.com', user.name_or_email

    user.name = '山田太郎'
    assert_equal '山田太郎', user.name_or_email
  end
end
