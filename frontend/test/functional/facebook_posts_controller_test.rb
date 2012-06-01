require 'test_helper'

class FacebookPostsControllerTest < ActionController::TestCase
  def test_show
    get :show, :id => FacebookPost.first
    assert_template 'show'
  end
end
