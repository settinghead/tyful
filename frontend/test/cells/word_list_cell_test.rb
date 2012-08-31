require 'test_helper'

class WordListCellTest < Cell::TestCase
  test "source" do
    invoke :source
    assert_select "p"
  end
  

end
