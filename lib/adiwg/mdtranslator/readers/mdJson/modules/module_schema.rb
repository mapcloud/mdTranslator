# unpack schema
# Reader - ADIwg JSON to internal data structure

# History:
# 	Stan Smith 2016-11-02 original script

module ADIWG
    module Mdtranslator
        module Readers
            module MdJson

                module Schema

                    def self.unpack(hSchema, responseObj)

                        # return nil object if input is empty
                        if hSchema.empty?
                            responseObj[:readerExecutionMessages] << 'Schema object is empty'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # instance classes needed in script
                        intMetadataClass = InternalMetadata.new
                        intSchema = intMetadataClass.newSchema

                        # schema - name (required)
                        if hSchema.has_key?('name')
                            intSchema[:name] = hSchema['name']
                        end
                        if intSchema[:name].nil? || intSchema[:name] == ''
                            responseObj[:readerExecutionMessages] << 'Schema is missing name'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # schema - version (required)
                        if hSchema.has_key?('version')
                            intSchema[:version] = hSchema['version']
                        end
                        if intSchema[:version].nil? || intSchema[:version] == ''
                            responseObj[:readerExecutionMessages] << 'Schema is missing version'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        return intSchema

                    end

                end

            end
        end
    end
end
