# unpack allocation
# Reader - ADIwg JSON to internal data structure

# History:
#  Stan Smith 2017-08-30 refactored for mdJson schema 2.3
#  Stan Smith 2016-10-30 original script

require_relative 'module_onlineResource'

module ADIWG
   module Mdtranslator
      module Readers
         module MdJson

            module Allocation

               def self.unpack(hAlloc, responseObj)

                  # return nil object if input is empty
                  if hAlloc.empty?
                     responseObj[:readerExecutionMessages] << 'Allocation object is empty'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # instance classes needed in script
                  intMetadataClass = InternalMetadata.new
                  intAlloc = intMetadataClass.newAllocation

                  # allocation - id
                  if hAlloc.has_key?('sourceAllocationId')
                     if hAlloc['sourceAllocationId'] != ''
                        intAlloc[:id] = hAlloc['sourceAllocationId']
                     end
                  end

                  # allocation - amount (required)
                  if hAlloc.has_key?('amount')
                     intAlloc[:amount] = hAlloc['amount']
                  end
                  if intAlloc[:amount].nil? || intAlloc[:amount] == ''
                     responseObj[:readerExecutionMessages] << 'Allocation attribute is missing amount'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # allocation - currency (required)
                  if hAlloc.has_key?('currency')
                     intAlloc[:currency] = hAlloc['currency']
                  end
                  if intAlloc[:currency].nil? || intAlloc[:currency] == ''
                     responseObj[:readerExecutionMessages] << 'Allocation attribute is missing currency'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # allocation - source ID {contactId}
                  if hAlloc.has_key?('sourceId')
                     if hAlloc['sourceId'] != ''
                        intAlloc[:sourceId] = hAlloc['sourceId']
                     end
                  end

                  # allocation - recipient ID {contactId}
                  if hAlloc.has_key?('recipientId')
                     if hAlloc['recipientId'] != ''
                        intAlloc[:recipientId] = hAlloc['recipientId']
                     end
                  end

                  # allocation - matching {Boolean}
                  if hAlloc.has_key?('matching')
                     if hAlloc['matching'] === true
                        intAlloc[:matching] = hAlloc['matching']
                     end
                  end

                  # allocation - online resource [] {onlineResource}
                  if hAlloc.has_key?('onlineResource')
                     aOnlines = hAlloc['onlineResource']
                     aOnlines.each do |hOnline|
                        hReturn = OnlineResource.unpack(hOnline, responseObj)
                        unless hReturn.nil?
                           intAlloc[:onlineResources] << hReturn
                        end
                     end
                  end

                  # allocation - comment
                  if hAlloc.has_key?('comment')
                     if hAlloc['comment'] != ''
                        intAlloc[:comment] = hAlloc['comment']
                     end
                  end

                  return intAlloc

               end

            end

         end
      end
   end
end
