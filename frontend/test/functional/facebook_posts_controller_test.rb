require 'test_helper'

class FacebookPostsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  def test_show
    get :show, :id => FacebookPost.first
    assert_template 'show'
  end
end
