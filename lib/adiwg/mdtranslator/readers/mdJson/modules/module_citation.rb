# unpack citation
# Reader - ADIwg JSON to internal data structure

# History:
#   Stan Smith 2016-10-13 refactored for mdJson 2.0
#   Stan Smith 2015-08-28 added alternate title
#   Stan Smith 2015-07-14 refactored to remove global namespace constants
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (responseObj)
#   Stan Smith 2014-12-30 refactored
#   Stan Smith 2014-12-19 refactored to return nil when hCitation is empty
#   Stan Smith 2014-12-15 refactored to handle namespacing readers and writers
#   Stan Smith 2014-08-18 changed additionalIdentifier section to identifier schema 0.6.0
#   Stan Smith 2014-07-03 resolve require statements using Mdtranslator.reader_module
#   Stan Smith 2014-04-25 modified to support json schema 0.3.0
# 	Stan Smith 2013-08-26 original script

require_relative 'module_date'
require_relative 'module_responsibleParty'
require_relative 'module_onlineResource'
require_relative 'module_identifier'
require_relative 'module_series'
require_relative 'module_graphic'

module ADIWG
   module Mdtranslator
      module Readers
         module MdJson

            module Citation

               def self.unpack(hCitation, responseObj)


                  # return nil object if input is empty
                  if hCitation.empty?
                     responseObj[:readerExecutionMessages] << 'Citation object is empty'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # instance classes needed in script
                  intMetadataClass = InternalMetadata.new
                  intCitation = intMetadataClass.newCitation

                  # citation - title (required)
                  if hCitation.has_key?('title')
                     intCitation[:title] = hCitation['title']
                  end
                  if intCitation[:title].nil? || intCitation[:title] == ''
                     responseObj[:readerExecutionMessages] << 'Citation attribute title is missing'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # citation - alternate title []
                  if hCitation.has_key?('alternateTitle')
                     hCitation['alternateTitle'].each do |item|
                        if item != ''
                           intCitation[:alternateTitles] << item
                        end
                     end
                  end

                  # citation - date []
                  if hCitation.has_key?('date')
                     aItems = hCitation['date']
                     aItems.each do |item|
                        hReturn = Date.unpack(item, responseObj)
                        unless hReturn.nil?
                           intCitation[:dates] << hReturn
                        end
                     end
                  end

                  # citation - edition
                  if hCitation.has_key?('edition')
                     if hCitation['edition'] != ''
                        intCitation[:edition] = hCitation['edition']
                     end
                  end

                  # citation - responsible party []
                  if hCitation.has_key?('responsibleParty')
                     aItems = hCitation['responsibleParty']
                     aItems.each do |item|
                        hReturn = ResponsibleParty.unpack(item, responseObj)
                        unless hReturn.nil?
                           intCitation[:responsibleParties] << hReturn
                        end
                     end
                  end

                  # citation - presentation form []
                  if hCitation.has_key?('presentationForm')
                     hCitation['presentationForm'].each do |item|
                        if item != ''
                           intCitation[:presentationForms] << item
                        end
                     end
                  end

                  # citation - identifier []
                  if hCitation.has_key?('identifier')
                     aItems = hCitation['identifier']
                     aItems.each do |item|
                        hReturn = Identifier.unpack(item, responseObj)
                        unless hReturn.nil?
                           intCitation[:identifiers] << hReturn
                        end
                     end
                  end

                  # citation - series
                  if hCitation.has_key?('series')
                     hObject = hCitation['series']
                     unless hObject.empty?
                        hReturn = Series.unpack(hObject, responseObj)
                        unless hReturn.nil?
                           intCitation[:series] = hReturn
                        end
                     end
                  end

                  # citation - other details
                  if hCitation.has_key?('otherCitationDetails')
                     hCitation['otherCitationDetails'].each do |item|
                        if item != ''
                           intCitation[:otherDetails] << item
                        end
                     end
                  end

                  # citation - online resource []
                  if hCitation.has_key?('onlineResource')
                     aItems = hCitation['onlineResource']
                     aItems.each do |item|
                        hReturn = OnlineResource.unpack(item, responseObj)
                        unless hReturn.nil?
                           intCitation[:onlineResources] << hReturn
                        end
                     end
                  end

                  # citation - graphic []
                  if hCitation.has_key?('graphic')
                     aItems = hCitation['graphic']
                     aItems.each do |item|
                        hReturn = Graphic.unpack(item, responseObj)
                        unless hReturn.nil?
                           intCitation[:browseGraphics] << hReturn
                        end
                     end
                  end

                  return intCitation

               end

            end

         end
      end
   end
end
