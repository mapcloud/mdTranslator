# unpack legal constraint
# Reader - ADIwg JSON to internal data structure

# History:
# 	Stan Smith 2016-10-15 original script

require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_constraint')

module ADIWG
    module Mdtranslator
        module Readers
            module MdJson

                module LegalConstraint

                    def self.unpack(hLegalCon, responseObj)

                        # return nil object if input is empty
                        if hLegalCon.empty?
                            responseObj[:readerExecutionMessages] << 'Legal Constraint object is empty'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # instance classes needed in script
                        intMetadataClass = InternalMetadata.new
                        intLegalCon= intMetadataClass.newLegalConstraint

                        # legal constraint - constraint {constraint}
                        if hLegalCon.has_key?('constraint')
                            hCon = hLegalCon['constraint']
                            unless hCon.empty?
                                intLegalCon[:constraint] = Constraint.unpack(hCon, responseObj)
                            end
                        end

                        # legal constraint - use constraint []
                        if hLegalCon.has_key?('useConstraint')
                            hLegalCon['useConstraint'].each do |item|
                                if item != ''
                                    intLegalCon[:useCodes] << item
                                end
                            end
                        end

                        # legal constraint - access constraint []
                        if hLegalCon.has_key?('accessConstraint')
                            hLegalCon['accessConstraint'].each do |item|
                                if item != ''
                                    intLegalCon[:accessCodes] << item
                                end
                            end
                        end

                        # legal constraint - other constraint []
                        if hLegalCon.has_key?('otherConstraint')
                            hLegalCon['otherConstraint'].each do |item|
                                if item != ''
                                    intLegalCon[:otherCodes] << item
                                end
                            end
                        end

                        if intLegalCon[:constraint][:useLimitation].empty? &&
                            intLegalCon[:constraint][:releasability].empty? &&
                            intLegalCon[:useCodes].empty? &&
                            intLegalCon[:accessCodes].empty? &&
                            intLegalCon[:otherCodes].empty?
                            responseObj[:readerExecutionMessages] << 'Legal Constraint was not declared'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        return intLegalCon

                    end

                end

            end
        end
    end
end
