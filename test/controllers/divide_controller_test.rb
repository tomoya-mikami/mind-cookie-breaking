require 'test_helper'

class DivideControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get divide_index_url
    assert_response :success
  end

end
