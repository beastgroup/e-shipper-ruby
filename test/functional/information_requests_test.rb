require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

class InformationRequestsTest  < MiniTest::Test
  include FunctionalTestHelper

  def setup
    @order_id = sample_order_id
  end

  def test_e_shipper_order_information
    options = { order_id: @order_id }

    response = client.order_information options
    refute_nil response
    assert response.is_a?(EShipper::InformationReply)
    assert_equal @order_id, response.order_id
    assert response.shipment_date
    assert response.status
    refute_empty response.history
  end
end
