# Reader - fgdc to internal data structure
# unpack fgdc entity attribute

# History:
#  Stan Smith 2017-09-06 original script

require 'uuidtools'
require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_enumerated'
require_relative 'module_range'

module ADIWG
   module Mdtranslator
      module Readers
         module Fgdc

            module Attribute

               def self.unpack(xAttribute, hDictionary, hResponseObj)

                  # instance classes needed in script
                  intMetadataClass = InternalMetadata.new
                  hAttribute = intMetadataClass.newEntityAttribute

                  # entity attribute 5.1.2.1 (attrlabl) - attribute name
                  # -> dataDictionary.entities.attributes.attributeCode
                  code = xAttribute.xpath('./attrlabl').text
                  unless code.empty?
                     hAttribute[:attributeName] = code
                     hAttribute[:attributeCode] = code
                  end

                  # entity attribute 5.1.2.2 (attrdef) - attribute definition
                  # -> dataDictionary.entities.attributes.attributeDefinition
                  definition = xAttribute.xpath('./attrdef').text
                  unless definition.empty?
                     hAttribute[:attributeDefinition] = definition
                  end

                  # entity attribute 5.1.2.3 (attrdefs) - attribute definition source
                  # -> not mapped

                  # entity attribute 5.1.2.4 (attrdomv) - attribute domain value
                  axDomain = xAttribute.xpath('./attrdomv')
                  unless axDomain.empty?
                     hDomain = intMetadataClass.newDictionaryDomain
                     hDomain[:domainId] = UUIDTools::UUID.random_create.to_s
                     hDomain[:domainCode] = code
                     hDomain[:domainDescription] = 'FGDC enumerated domain'

                     axDomain.each do |xDomain|

                        # entity attribute 5.1.2.4.1 (edom) - enumerated domain
                        xEnumeration = xDomain.xpath('./edom')
                        unless xEnumeration.empty?
                           hItem = Enumerated.unpack(xEnumeration, hResponseObj)
                           hDomain[:domainItems] << hItem
                        end

                        # entity attribute 5.1.2.4.2 (rdom) - range domain
                        xRange = xDomain.xpath('./rdom')
                        unless xRange.empty?
                           Range.unpack(xRange, hAttribute, hResponseObj)
                        end

                        # entity attribute 5.1.2.4.3 (codesetd) - codeset domain

                           # entity attribute 5.1.2.4.3.1 (codesetn) - codeset name
                           # -> not mapped

                           # entity attribute 5.1.2.4.3.2 (codesets) - codeset source
                           # -> not mapped

                        # entity attribute 5.1.2.4.4 (udom) - unrepresentable domain
                        # -> not mapped

                     end

                     unless hDomain[:domainItems].empty?
                        hAttribute[:domainId] = hDomain[:domainId]
                        hDictionary[:domains] << hDomain
                     end

                  end

                  # entity attribute 5.1.2.5 (begdatea) - beginning date of attribute values
                  # -> not mapped

                  # entity attribute 5.1.2.6 (enddatea) - ending date of attribute values
                  # -> not mapped

                  # entity attribute 5.1.2.7 (attrvai) - attribute value accuracy information

                  # entity attribute 5.1.2.7.1 (attrva) - attribute value accuracy
                  # -> not mapped

                  # entity attribute 5.1.2.7.2 (attrvae) - attribute value accuracy explanation
                  # -> not mapped

                  hAttribute

               end

            end

         end
      end
   end
end