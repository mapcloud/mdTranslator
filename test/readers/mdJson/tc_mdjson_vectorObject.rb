# MdTranslator - minitest of
# reader / mdJson / module_vectorObject

# History:
#   Stan Smith 2017-01-16 added parent class to run successfully within rake
#   Stan Smith 2016-10-19 original script

require_relative 'mdjson_test_parent'
require 'adiwg/mdtranslator/readers/mdJson/modules/module_vectorObject'

class TestReaderMdJsonVectorObject < TestReaderMdJsonParent

    # set variables for test
    @@NameSpace = ADIWG::Mdtranslator::Readers::MdJson::VectorObject
    aIn = TestReaderMdJsonParent.getJson('vectorObject.json')
    @@hIn = aIn['vectorObject'][0]

    def test_vectorObject_schema

        errors = TestReaderMdJsonParent.testSchema(@@hIn, 'vectorRepresentation.json', :fragment=>'vectorObject')
        assert_empty errors

    end

    def test_complete_vectorObject_object

        hIn = Marshal::load(Marshal.dump(@@hIn))
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal 'objectType', metadata[:objectType]
        assert_equal 9, metadata[:objectCount]
        assert hResponse[:readerExecutionPass]
        assert_empty hResponse[:readerExecutionMessages]

    end

    def test_vectorObject_empty_objectType

        hIn = Marshal::load(Marshal.dump(@@hIn))
        hIn['objectType'] = ''
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_nil metadata
        refute hResponse[:readerExecutionPass]
        refute_empty hResponse[:readerExecutionMessages]

    end

    def test_vectorObject_missing_objectType

        hIn = Marshal::load(Marshal.dump(@@hIn))
        hIn.delete('objectType')
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_nil metadata
        refute hResponse[:readerExecutionPass]
        refute_empty hResponse[:readerExecutionMessages]

    end

    def test_vectorObject_empty_elements

        hIn = Marshal::load(Marshal.dump(@@hIn))
        hIn['objectCount'] = ''
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal 'objectType', metadata[:objectType]
        assert_nil metadata[:objectCount]
        assert hResponse[:readerExecutionPass]
        assert_empty hResponse[:readerExecutionMessages]

    end

    def test_vectorObject_missing_elements

        hIn = Marshal::load(Marshal.dump(@@hIn))
        hIn.delete('objectCount')
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal 'objectType', metadata[:objectType]
        assert_nil metadata[:objectCount]
        assert hResponse[:readerExecutionPass]
        assert_empty hResponse[:readerExecutionMessages]

    end

    def test_empty_vectorObject_object

        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack({}, hResponse)

        assert_nil metadata
        refute hResponse[:readerExecutionPass]
        refute_empty hResponse[:readerExecutionMessages]

    end

end
