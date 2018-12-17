require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

class ShippingRequestsTest  < MiniTest::Test
  include FunctionalTestHelper

  def setup
    @options = shipping_request_options
  end

  def test_parse_shipping_e_shipper_without_service_id
    response = order_request
    assert response.is_a?(EShipper::ShippingReply)
    refute_empty response.tracking_url
    refute_empty response.service_name
    refute_empty response.package_tracking_numbers
  end

  def test_parse_shipping_e_shipper_with_service_id
    response = order_request(service_id: '4')
    assert_equal 'Purolator Express', response.service_name
    refute_empty response.tracking_url
    refute_empty response.service_name
    refute_empty response.package_tracking_numbers
  end

  def test_sending_two_continuous_requests
    order_request
    order_request
  end

  def test_sending_a_quote_request_following_by_a_shipping_one_dont_break_the_server
    options = shipping_request_options
    options[:from] = {:id => "123", :company => "Hospital", :address1 => "1403 29 Street NW",
      :city => "Calgary", :state => "AB", :zip => "T2N2T9", :country => "CA",
      :phone => '888-888-8888', :attention => 'vitamonthly', :email => 'damien@gmail.com'}

    options[:to] == {:id => '234', :company => "Hospital", :address1 => "909 Bd de la Verendrye",
      :city => "Gatineau", :state => "QC", :zip => "J8V2L6", :country => "CA",
    :phone => '888-888-8888', :attention => 'vitamonthly', :email => 'damien@gmail.com'}

    response = client.parse_quotes options
    refute_nil response

    order_request(options)
  end

  def test_obtaining_invoice_data
    options = {
      invoice: {
        broker_name: 'John Doe',
        contact_company: 'MERITCON INC',
        name: 'Jim',
        contact_name: 'Rizwan',
        contact_phone: '555-555-4444',
        dutiable: 'true',
        duty_tax_to: 'receiver',
      },
      items: [{
        code: '1234',
        description: 'Laptop computer',
        originCountry:  'US',
        quantity: '100',
        unitPrice: '1000.00',
        skuCode: '1234'
      }]
    }

    order_request(options)
  end
end
