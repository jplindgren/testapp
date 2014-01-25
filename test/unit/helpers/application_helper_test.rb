require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test "full_title helper with no page_title should return default title" do
  	assert_equal("MicroTwitter", full_title(''))
  end

  test "full_title helper with page_title should return default title plus page_title" do
  	assert_equal("MicroTwitter | Test Page", full_title('Test Page'))
  end

end
