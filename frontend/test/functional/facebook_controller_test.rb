require 'test_helper'

class FacebookControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    sign_in users(:one)
    
  end
  test "should get invite" do
    get :invite, :format => 'js'
    assert_response :success
  end

end
