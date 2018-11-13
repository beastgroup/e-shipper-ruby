require 'simplecov'
SimpleCov.start

require 'minitest'
require 'minitest/autorun'
require 'mocha'
require 'pry'

require 'singleton'

require File.expand_path(File.dirname(__FILE__) + '/../lib/e_shipper_ruby')

$client = EShipper::Client.instance

module FunctionalTestHelper
  def client
    EShipper::Client.instance
  end

  def order_request(options = {})
    response = client.parse_shipping(shipping_request_options.merge(options))
    refute_nil response, 'Error creating test order: empty response'
    assert client.validate_last_response, 'Error creating test order: invalid response'

    response
  end

  def sample_order_id
    response = order_request
    response.attributes.fetch('order_id')
  end

  def shipping_request_options
    options = {
      from: {
        id: '123',
        company: 'fake company',
        address1: '650 CIT Drive',
        city: 'Livingston',
        state: 'ON',
        zip: 'L4J7Y9',
        country: 'CA',
        phone: '888-888-8888',
        attention: 'fake attention',
        email: 'eshipper@gmail.com'
      },
      to: {
        id: '234',
        company: 'Healthwave',
        address1: '185 Rideau Street',
        address2: 'Second Floor',
        city: 'Ottawa',
        state: 'ON',
        zip: 'K1N 5X8',
        country: 'CA',
        phone: '888-888-8888',
        attention: 'fake attention',
        email: 'eshipper@gmail.com'
      }
    }

    t = Time.now + 5 * 24 * 60 * 60 # 5 days from now

    options[:pickup] = {:contactName => "Test Name", :phoneNumber => "888-888-8888", :pickupDate => t.strftime("%Y-%m-%d"),
        :pickupTime => t.strftime("%H:%M"), :closingTime => (t+2*60*60).strftime("%H:%M"), :location => "Front Door"}

    package1_data = {:length => "15", :width => "10", :height => "12", :weight => "10",
      :insuranceAmount => "120", :codAmount => "120"}
    package2_data = {:length => "15", :width => "10", :height => "10", :weight => "5",
      :insuranceAmount => "120", :codAmount => "120"}
    options[:packages] = [package1_data, package2_data]

    reference1_data = {:name => "Vitamonthly", :code => "123"}
    reference2_data = {:name => "Heroku", :code => "456"}
    options[:references] = [reference1_data, reference2_data]
    options
  end
end
