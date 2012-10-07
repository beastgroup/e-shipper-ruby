module EShipper
  module ParsingHelpers
    def error_messages(xml_data)
      errors = { :errors => [] }
      xml_errors = xml_data.css('Error')
      unless xml_errors.empty?
        xml_errors.each do |xml_error|
         errors[:errors] << try_extract(xml_error, 'Message')
        end
      end
      errors
    end
    
    def try_extract(xml_node, value)
      value = value.to_s.camel_case
      xml_node.attributes[value].content
    rescue NoMethodError
      ''
    end
    
    def try_direct_extract(xml_node, selector, attr = nil)
      attr ? xml_node.css(selector)[0][attr] : xml_node.css(selector)[0].content
    rescue NoMethodError
      ''
    end
    
    def data(xml_node, attrs)
      data = {}
      attrs.each { |attr| data[attr] = try_extract(xml_node, attr) }
      data
    end
  end
end