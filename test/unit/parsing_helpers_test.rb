require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

class ParsingHelpersTest  < MiniTest::Test
  include EShipper::ParsingHelpers

  def test_try_extract_returns_xml_node_content_or_blank
    xml_path = "#{File.dirname(__FILE__)}/../support/quote.xml"
    doc = Nokogiri::XML(File.open(xml_path))
    xml_node = doc.css('Quote')[0]
    
    assert_equal '2', try_extract(xml_node, 'carrierId')
    assert_equal '4', try_extract(xml_node, :service_id)
    assert_equal '', try_extract(xml_node, 'notAvailableData')
  end
  
  def test_try_direct_extract_returns_attr_css_content_or_blank
    xml_path = "#{File.dirname(__FILE__)}/../support/shipping.xml"
    doc = Nokogiri::XML(File.open(xml_path))
    xml_node = doc.css('ShippingReply')[0]
    
    assert_equal '2065293', try_direct_extract(xml_node, 'Order', 'id')
    assert_equal 'http://shipnow.purolator.com/shiponline/track/purolatortrack.asp?pinno=329014716131,329014716149,', try_direct_extract(xml_node, 'TrackingURL')
    assert_equal '', try_extract(xml_node, 'NotExist')
  end
  
  def test_error_messages_traps_e_shipper_error_messages_in_last_response
    xml_path = "#{File.dirname(__FILE__)}/../support/error.xml"
    doc = Nokogiri::XML(File.open(xml_path))

    assert_equal ["Required field: Name is missing."], error_messages(doc)

    xml_path = "#{File.dirname(__FILE__)}/../support/error_2.xml"
    doc = Nokogiri::XML(File.open(xml_path))

    assert_equal ["Required field:  is missing."], error_messages(doc)
  end
end