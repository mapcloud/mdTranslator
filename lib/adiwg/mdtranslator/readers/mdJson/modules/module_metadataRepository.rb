# unpack metadata distribution
# Reader - ADIwg JSON to internal data structure

# History:
#  Stan Smith 2017-06-06 add citation to repository
# 	Stan Smith 2017-02-09 original script

require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module MdJson

            module MetadataRepository

               def self.unpack(hMdDist, responseObj)

                  # return nil object if input is empty
                  if hMdDist.empty?
                     responseObj[:readerExecutionMessages] << 'Metadata Repository object is empty'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # instance classes needed in script
                  intMetadataClass = InternalMetadata.new
                  intMdDist = intMetadataClass.newMetadataRepository

                  # metadata distribution - repository (required)
                  if hMdDist.has_key?('repository')
                     intMdDist[:repository] = hMdDist['repository']
                  end
                  if intMdDist[:repository].nil? || intMdDist[:repository] == ''
                     responseObj[:readerExecutionMessages] << 'Metadata Repository repository is missing'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # metadata distribution - citation
                  if hMdDist.has_key?('citation')
                     unless hMdDist['citation'].empty?
                        hReturn = Citation.unpack(hMdDist['citation'], responseObj)
                        unless hReturn.nil?
                           intMdDist[:citation] = hReturn
                        end
                     end
                  end

                  # metadata distribution - metadata format
                  if hMdDist.has_key?('metadataStandard')
                     if hMdDist['metadataStandard'] != ''
                        intMdDist[:metadataStandard] = hMdDist['metadataStandard']
                     end
                  end

                  return intMdDist

               end

            end

         end
      end
   end
end
