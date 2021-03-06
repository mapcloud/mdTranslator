# MdTranslator - minitest of
# parent class for all tc_mdjson tests

# History:
# Stan Smith 2017-01-15 original script

require 'minitest/autorun'
require 'json'
require 'json-schema'
require 'adiwg-mdjson_schemas'
require 'adiwg/mdtranslator/readers/mdJson/modules/module_mdJson'

class TestReaderMdJsonParent < MiniTest::Test

    @@responseObj = {
        readerExecutionPass: true,
        readerExecutionMessages: []
    }

    # get json file for tests from examples folder
    def self.getJson(fileName)

        file = File.join(File.dirname(__FILE__), 'testData', fileName)
        file = File.open(file, 'r')
        jsonFile = file.read
        file.close
        return JSON.parse(jsonFile)

    end

    # set contact list for test modules
    def self.setContacts

        # create new internal metadata container for the reader
        intMetadataClass = InternalMetadata.new
        intObj = intMetadataClass.newBase

        # first contact
        intObj[:contacts] << intMetadataClass.newContact
        intObj[:contacts][0][:contactId] = 'individualId0'
        intObj[:contacts][0][:isOrganization] = false

        # second contact
        intObj[:contacts] << intMetadataClass.newContact
        intObj[:contacts][1][:contactId] = 'individualId1'
        intObj[:contacts][1][:isOrganization] = false

        # third contact
        intObj[:contacts] << intMetadataClass.newContact
        intObj[:contacts][2][:contactId] = 'organizationId0'
        intObj[:contacts][2][:isOrganization] = true

        ADIWG::Mdtranslator::Readers::MdJson::MdJson.setContacts(intObj[:contacts])

    end

    # test schema for reader modules
    def self.testSchema(mdJson, schema, fragment: nil, remove: [])

        # load all schemas with 'true' to prohibit additional parameters
        ADIWG::MdjsonSchemas::Utils.load_schemas(false)

        # load schema segment and make all elements required and prevent additional parameters
        strictSchema = ADIWG::MdjsonSchemas::Utils.load_strict(schema)

        # remove unwanted parameters from the required array
        unless remove.empty?
            strictSchema['required'] = strictSchema['required'] - remove
        end

        # build relative path to schema fragment
        fragmentPath = nil
        if fragment
            fragmentPath = '#/definitions/' + fragment
        end

        # scan
        return JSON::Validator.fully_validate(strictSchema, mdJson, :fragment=>fragmentPath)

    end

end
