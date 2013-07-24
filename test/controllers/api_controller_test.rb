require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get member" do
    get :member
    assert_response :success
  end

end
