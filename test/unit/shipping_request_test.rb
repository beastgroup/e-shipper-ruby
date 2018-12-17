require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

class ShippingRequestTest  < MiniTest::Test
  def setup
  	@shipping_request = EShipper::ShippingRequest.new

    @options = {}
    @options[:from] = {:id => "123", :company => "fake company", :address1 => "650 CIT Drive",
      :city => "Livingston", :state => "ON", :zip => "L4J7Y9", :country => "CA",
      :phone => '888-888-8888', :attention => 'fake attention', :email => 'eshipper@gmail.com'}

    @options[:to] = {:id => "234", :company => "Healthwave", :address1 => "185 Rideau Street", :address2=>"Second Floor",
      :city => "Ottawa", :state => "ON", :zip => "K1N 5X8", :country => "CA",
      :phone => '888-888-8888', :attention => 'fake attention', :email => 'eshipper@gmail.com'}

    t = Time.now + 5 * 24 * 60 * 60 # 5 days from now

    @options[:pickup] = {:contactName => "Test Name", :phoneNumber => "888-888-8888", :pickupDate => t.strftime("%Y-%m-%d"),
        :pickupTime => t.strftime("%H:%M"), :closingTime => (t+2*60*60).strftime("%H:%M"), :location => "Front Door"}

    @options[:packages] = [{:length => "15", :width => "10", :height => "12", :weight => "10",
      :insuranceAmount => "120", :codAmount => "120"}]

    @options[:references] = [{:name => "Vitamonthly", :code => "123"}]

    @options[:invoice] = { :broker_name => 'John Doe', :contact_company => 'MERITCON INC',
      :name => 'Jim', :contact_name => 'Rizwan', :contact_phone => '555-555-4444',
      :dutiable => 'true', :duty_tax_to => 'receiver'
    }

    @options[:items] = [{:code => '1234', :description => 'Laptop computer', :originCountry =>  'US',
        :quantity => '100', :unitPrice => '1000.00', :skuCode => '1234'}]

	@options[:cod] = { :payment_type => 'check', :address => @options[:to] }
  end

  def test_request_body_generating_a_well_formed_xml_quote_request
	@shipping_request.prepare! @options
  	xml = @shipping_request.request_body
  	doc = Nokogiri::XML(xml)

    refute_empty doc.css('ShippingRequest')
    refute_empty doc.css('From')
    refute_empty doc.css('To')
    refute_empty doc.css('Pickup')
    refute_empty doc.css('Packages')
    refute_empty doc.css('Reference')
    refute_empty doc.css('CustomsInvoice')
    refute_empty doc.css('Payment')
    refute_empty doc.css('BillTo')
    refute_empty doc.css('Item')
    refute_empty doc.css('COD')
    refute_empty doc.css('CODReturnAddress')
  end

  def test_generic_options
	@options.merge!({:options => { :dangerousGoodsType => true,
	  :isSaturdayService => true }})
    @shipping_request.prepare! @options

	xml = @shipping_request.request_body
    doc = Nokogiri::XML(xml)

    refute_empty doc.css('ShippingRequest')
    refute_empty doc.css('ShippingRequest[dangerousGoodsType]')
    refute_empty doc.css('ShippingRequest[isSaturdayService]')
  end
end
