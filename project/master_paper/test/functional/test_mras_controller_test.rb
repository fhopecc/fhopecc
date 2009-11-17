require File.dirname(__FILE__) + '/../test_helper'
require 'test_mras_controller'

# Re-raise errors caught by the controller.
class TestMRASController; def rescue_action(e) raise e end; end

class TestMRASControllerTest < Test::Unit::TestCase
  def setup
    @controller = TestMRASController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
