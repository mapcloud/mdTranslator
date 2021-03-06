# unpack source
# Reader - ADIwg JSON to internal data structure

# History:
#   Stan Smith 2016-10-17 refactored for mdJson 2.0
#   Stan Smith 2015-07-14 refactored to remove global namespace constants
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (responseObj)
#   Stan Smith 2014-12-15 refactored to handle namespacing readers and writers
#   Stan Smith 2014-07-03 resolve require statements using Mdtranslator.reader_module
# 	Stan Smith 2013-11-26 original script

require_relative 'module_citation'
require_relative 'module_processStep'
require_relative 'module_spatialReference'
require_relative 'module_scope'
require_relative 'module_spatialResolution'

module ADIWG
   module Mdtranslator
      module Readers
         module MdJson

            module Source

               def self.unpack(hSource, responseObj)

                  # return nil object if input is empty
                  if hSource.empty?
                     responseObj[:readerExecutionMessages] << 'Source object is empty'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # instance classes needed in script
                  intMetadataClass = InternalMetadata.new
                  intSource = intMetadataClass.newDataSource

                  # source - source ID
                  if hSource.has_key?('sourceId')
                     unless hSource['sourceId'] == ''
                        intSource[:sourceId] = hSource['sourceId']
                     end
                  end

                  # source - description (required)
                  if hSource.has_key?('description')
                     intSource[:description] = hSource['description']
                  end
                  if intSource[:description].nil? || intSource[:description] == ''
                     responseObj[:readerExecutionMessages] << 'Source description is missing'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # source - source citation
                  if hSource.has_key?('sourceCitation')
                     hObject = hSource['sourceCitation']
                     unless hObject.empty?
                        hReturn = Citation.unpack(hObject, responseObj)
                        unless hReturn.nil?
                           intSource[:sourceCitation] = hReturn
                        end
                     end
                  end

                  # source - source metadata []
                  if hSource.has_key?('metadataCitation')
                     aCitation = hSource['metadataCitation']
                     aCitation.each do |item|
                        hCitation = Citation.unpack(item, responseObj)
                        unless hCitation.nil?
                           intSource[:metadataCitation] << hCitation
                        end
                     end
                  end

                  # source - spatial resolution
                  if hSource.has_key?('spatialResolution')
                     hObject = hSource['spatialResolution']
                     unless hObject.empty?
                        hReturn = SpatialResolution.unpack(hObject, responseObj)
                        unless hReturn.nil?
                           intSource[:spatialResolution] = hReturn
                        end
                     end
                  end

                  # source - reference system
                  if hSource.has_key?('referenceSystem')
                     hObject = hSource['referenceSystem']
                     unless hObject.empty?
                        hReturn = SpatialReferenceSystem.unpack(hObject, responseObj)
                        unless hReturn.nil?
                           intSource[:referenceSystem] = hReturn
                        end
                     end
                  end

                  # source - source steps []
                  if hSource.has_key?('sourceProcessStep')
                     aSteps = hSource['sourceProcessStep']
                     aSteps.each do |item|
                        hStep = ProcessStep.unpack(item, responseObj)
                        unless hStep.nil?
                           intSource[:sourceSteps] << hStep
                        end
                     end
                  end

                  # source - scope {scope}
                  if hSource.has_key?('scope')
                     hObject = hSource['scope']
                     unless hObject.empty?
                        hReturn = Scope.unpack(hObject, responseObj)
                        unless hReturn.nil?
                           intSource[:scope] = hReturn
                        end
                     end
                  end

                  return intSource

               end

            end

         end
      end
   end
end
