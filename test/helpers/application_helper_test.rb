require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full_title helper" do
    assert_equal "Help | Ruby on Rails Tutorial Sample App", full_title("Help")
    assert_equal "Ruby on Rails Tutorial Sample App", full_title
  end
end