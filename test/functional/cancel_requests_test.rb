require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

class CancelRequestsTest  < MiniTest::Test
  include FunctionalTestHelper

  def setup
    @order_id = sample_order_id
  end

  def test_e_shipper_cancel_shipping
    options = { :order_id => @order_id }

    response = client.cancel_shipping options

    refute_nil response
    assert response.is_a?(EShipper::CancelReply)
    assert_equal @order_id, response.order_id
    assert_equal 'Order has been cancelled!', response.message
    assert_equal 'CANCELLED', response.status
  end
end
