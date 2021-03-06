# unpack taxonomic classification
# Reader - ADIwg JSON to internal data structure

# History:
#   Stan Smith 2017-01-31 added taxonomicSystemId
#   Stan Smith 2016-10-22 original script

require_relative 'module_taxonomicClassification'

module ADIWG
    module Mdtranslator
        module Readers
            module MdJson

                module TaxonomicClassification

                    def self.unpack(hTaxClass, responseObj)

                        # return nil object if input is empty
                        if hTaxClass.empty?
                            responseObj[:readerExecutionMessages] << 'Taxonomic Classification object is empty'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # instance classes needed in script
                        intMetadataClass = InternalMetadata.new
                        intTaxClass = intMetadataClass.newTaxonClass

                        # taxonomic classification - system ID
                        if hTaxClass.has_key?('taxonomicSystemId')
                            s = hTaxClass['taxonomicSystemId']
                            unless s == ''
                                intTaxClass[:taxonId] = s
                            end
                        end

                        # taxonomic classification - taxon rank (required)
                        if hTaxClass.has_key?('taxonomicRank')
                            intTaxClass[:taxonRank] = hTaxClass['taxonomicRank']
                        end
                        if intTaxClass[:taxonRank].nil? || intTaxClass[:taxonRank] == ''
                            responseObj[:readerExecutionMessages] << 'Taxonomic Classification attribute taxonomicRank is missing'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # taxonomic classification - latin name (required)
                        if hTaxClass.has_key?('latinName')
                            intTaxClass[:taxonValue] = hTaxClass['latinName']
                        end
                        if intTaxClass[:taxonValue].nil? || intTaxClass[:taxonValue] == ''
                            responseObj[:readerExecutionMessages] << 'Taxonomic Classification attribute latinName is missing'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # taxonomic classification - common name []
                        if hTaxClass.has_key?('commonName')
                            hTaxClass['commonName'].each do |item|
                                if item != ''
                                    intTaxClass[:commonNames] << item
                                end
                            end
                        end

                         # taxonomic classification - taxonomic classification [taxonomicClassification]
                        if hTaxClass.has_key?('subClassification')
                            aItems = hTaxClass['subClassification']
                            aItems.each do |item|
                                hReturn = TaxonomicClassification.unpack(item, responseObj)
                                unless hReturn.nil?
                                    intTaxClass[:subClasses] << hReturn
                                end
                            end
                        end

                        return intTaxClass

                    end

                end

            end
        end
    end
end
