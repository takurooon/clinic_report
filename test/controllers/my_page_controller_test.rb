require 'test_helper'

class MyPageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get my_page_index_url
    assert_response :success
  end

end
