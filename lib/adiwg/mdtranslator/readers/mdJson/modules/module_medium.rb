# unpack medium
# Reader - ADIwg JSON to internal data structure

# History:
#   Stan Smith 2016-10-20 original script

require_relative 'module_citation'
require_relative 'module_identifier'

module ADIWG
    module Mdtranslator
        module Readers
            module MdJson

                module Medium

                    def self.unpack(hMedium, responseObj)

                        # return nil object if input is empty
                        if hMedium.empty?
                            responseObj[:readerExecutionMessages] << 'Medium object is empty'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # instance classes needed in script
                        intMetadataClass = InternalMetadata.new
                        intMedium = intMetadataClass.newMedium

                        # medium - mediumSpecification {citation}
                        if hMedium.has_key?('mediumSpecification')
                            hObject = hMedium['mediumSpecification']
                            unless hObject.empty?
                                hReturn = Citation.unpack(hObject, responseObj)
                                unless hReturn.nil?
                                    intMedium[:mediumSpecification] = hReturn
                                end
                            end
                        end

                        # medium - density
                        if hMedium.has_key?('density')
                            if hMedium['density'] != ''
                                intMedium[:density] = hMedium['density']
                            end
                        end

                        # medium - units
                        if hMedium.has_key?('units')
                            if hMedium['units'] != ''
                                intMedium[:units] = hMedium['units']
                            end
                        end

                        # medium - numberOfVolumes
                        if hMedium.has_key?('numberOfVolumes')
                            if hMedium['numberOfVolumes'] != ''
                                intMedium[:numberOfVolumes] = hMedium['numberOfVolumes']
                            end
                        end

                        # medium - numberOfVolumes
                        if hMedium.has_key?('numberOfVolumes')
                            if hMedium['numberOfVolumes'] != ''
                                intMedium[:numberOfVolumes] = hMedium['numberOfVolumes']
                            end
                        end

                        # medium - mediumFormat
                        if hMedium.has_key?('mediumFormat')
                            hMedium['mediumFormat'].each do |item|
                                if item != ''
                                    intMedium[:mediumFormat] << item
                                end
                            end
                        end

                        # medium - note
                        if hMedium.has_key?('note')
                            if hMedium['note'] != ''
                                intMedium[:note] = hMedium['note']
                            end
                        end

                        # medium - identifier
                        if hMedium.has_key?('identifier')
                            hObject = hMedium['identifier']
                            unless hObject.empty?
                                hReturn = Identifier.unpack(hObject, responseObj)
                                unless hReturn.nil?
                                    intMedium[:identifier] = hReturn
                                end
                            end
                        end

                        return intMedium

                    end

                end

            end
        end
    end
end
