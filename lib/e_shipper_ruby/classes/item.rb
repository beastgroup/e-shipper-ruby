module EShipper
  class Item < EShipper::OpenStruct

    POSSIBLE_FIELDS = [:code, :description, :originCountry, :quantity, :unitPrice, :skuCode]

    REQUIRED_FIELDS = POSSIBLE_FIELDS
  end
end
