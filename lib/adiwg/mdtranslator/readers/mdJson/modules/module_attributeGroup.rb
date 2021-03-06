# unpack attribute group
# Reader - ADIwg JSON to internal data structure

# History:
# 	Stan Smith 2016-10-18 original script

require_relative 'module_attribute'

module ADIWG
    module Mdtranslator
        module Readers
            module MdJson

                module AttributeGroup

                    def self.unpack(hAttGroup, responseObj)

                        # return nil object if input is empty
                        if hAttGroup.empty?
                            responseObj[:readerExecutionMessages] << 'Attribute Group object is empty'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # instance classes needed in script
                        intMetadataClass = InternalMetadata.new
                        intAttGroup = intMetadataClass.newAttributeGroup

                        # attribute group - attribute content type [] (required)
                        if hAttGroup.has_key?('attributeContentType')
                            hAttGroup['attributeContentType'].each do |item|
                                if item != ''
                                    intAttGroup[:attributeContentTypes] << item
                                end
                            end
                        end
                        if intAttGroup[:attributeContentTypes].empty?
                            responseObj[:readerExecutionMessages] << 'Attribute Group attribute attributeContentType is missing'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # attribute group - attribute []
                        if hAttGroup.has_key?('attribute')
                            aItems = hAttGroup['attribute']
                            aItems.each do |item|
                                hReturn = Attribute.unpack(item, responseObj)
                                unless hReturn.nil?
                                    intAttGroup[:attributes] << hReturn
                                end
                            end
                        end

                        return intAttGroup

                    end

                end

            end
        end
    end
end
