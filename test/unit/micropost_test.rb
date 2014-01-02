require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  test "the truth" do
    assert true
  end
  
  should ensure_length_of(:content).is_at_most(140)	

end
