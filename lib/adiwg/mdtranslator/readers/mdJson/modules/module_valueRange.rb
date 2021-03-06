# unpack series
# Reader - ADIwg JSON to internal data structure

# History:
# 	Stan Smith 2017-11-01 original script

module ADIWG
   module Mdtranslator
      module Readers
         module MdJson

            module ValueRange

               def self.unpack(hRange, responseObj)

                  # return nil object if input is empty
                  if hRange.empty?
                     responseObj[:readerExecutionMessages] << 'Value Range object is empty'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # instance classes needed in script
                  intMetadataClass = InternalMetadata.new
                  intRange = intMetadataClass.newValueRange

                  # value range - minimum range value (required)
                  if hRange.has_key?('minRangeValue')
                     intRange[:minRangeValue] = hRange['minRangeValue']
                  end
                  if intRange[:minRangeValue].nil? || intRange[:minRangeValue] == ''
                     responseObj[:readerExecutionMessages] << 'Value Range object is missing minimum'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # value range - maximum range value (required)
                  if hRange.has_key?('maxRangeValue')
                     intRange[:maxRangeValue] = hRange['maxRangeValue']
                  end
                  if intRange[:maxRangeValue].nil? || intRange[:maxRangeValue] == ''
                     responseObj[:readerExecutionMessages] << 'Value Range object is missing maximum'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  return intRange

               end

            end

         end
      end
   end
end
