require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

class QuoteRequestTest  < MiniTest::Test
  def setup
  	@quote_request = EShipper::QuoteRequest.new

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

	@options[:cod] = { :payment_type => 'check', :address => @options[:to] }  
  end

  def test_request_body_generating_a_well_formed_xml_quote_request
    @quote_request.prepare! @options
    
  	xml = @quote_request.request_body
    doc = Nokogiri::XML(xml)

  	refute_empty doc.css('QuoteRequest')
    refute_empty doc.css('From')
    refute_empty doc.css('To')
    refute_empty doc.css('Pickup')
    refute_empty doc.css('Packages')
    refute_empty doc.css('COD')
    refute_empty doc.css('CODReturnAddress')
  end
  
  def test_generic_options
	@options.merge!({:options => { :dangerousGoodsType => true,
	  :isSaturdayService => true }})	  
    @quote_request.prepare! @options
    
	xml = @quote_request.request_body
    doc = Nokogiri::XML(xml)
    
    refute_empty doc.css('QuoteRequest')
    refute_empty doc.css('QuoteRequest[dangerousGoodsType]')
    refute_empty doc.css('QuoteRequest[isSaturdayService]')
  end
end