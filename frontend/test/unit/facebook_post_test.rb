require 'test_helper'

class FacebookPostTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert FacebookPost.new.valid?
  end
end
