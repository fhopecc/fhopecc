require File.dirname(__FILE__) + '/../test_helper'
class AuditTrailTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_audit_trail
    at = AuditTrail.find :first
    puts at.to_s
	end

end
