require 'test_helper'

class FacebookControllerTest < ActionController::TestCase
  
  test "should get invite" do
    get :invite, :format => 'js'
    assert_response :success
  end

end
