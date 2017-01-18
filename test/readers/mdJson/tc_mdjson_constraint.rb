# MdTranslator - minitest of
# reader / mdJson / module_constraint

# History:
#   Stan Smith 2017-01-16 added parent class to run successfully within rake
#   Stan Smith 2016-11-14 original script

require_relative 'mdjson_test_parent'
require 'adiwg/mdtranslator/readers/mdJson/modules/module_constraint'

class TestReaderMdJsonConstraint < TestReaderMdJsonParent

    # set constants and variables
    @@NameSpace = ADIWG::Mdtranslator::Readers::MdJson::Constraint
    aIn = TestReaderMdJsonParent.getJson('constraint.json')
    @@hIn = aIn['constraint'][0]

    def test_complete_constraint

        TestReaderMdJsonParent.setContacts
        hIn = Marshal::load(Marshal.dump(@@hIn))
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal 'use', metadata[:type]
        assert_equal 2, metadata[:useLimitation].length
        assert_equal 'useLimitation0', metadata[:useLimitation][0]
        assert_equal 'useLimitation1', metadata[:useLimitation][1]
        refute_empty metadata[:scope]
        assert_equal 2, metadata[:graphic].length
        assert_equal 2, metadata[:reference].length
        refute_empty metadata[:releasability]
        assert_equal 2, metadata[:responsibleParty].length
        assert_empty metadata[:legalConstraint]
        assert_empty metadata[:securityConstraint]
        assert hResponse[:readerExecutionPass]
        assert_empty hResponse[:readerExecutionMessages]

    end

    def test_empty_constraint_elements

        TestReaderMdJsonParent.setContacts
        hIn = Marshal::load(Marshal.dump(@@hIn))
        hIn['useLimitation'] = []
        hIn['scope'] = {}
        hIn['graphic'] = []
        hIn['reference'] = []
        hIn['releasability'] = {}
        hIn['responsibleParty'] = []
        hIn['legalConstraint'] = {}
        hIn['securityConstraint'] = {}
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal 'use', metadata[:type]
        assert_empty metadata[:useLimitation]
        assert_empty metadata[:scope]
        assert_empty metadata[:graphic]
        assert_empty metadata[:reference]
        assert_empty metadata[:releasability]
        assert_empty metadata[:responsibleParty]
        assert_empty metadata[:legalConstraint]
        assert_empty metadata[:securityConstraint]
        assert hResponse[:readerExecutionPass]
        assert_empty hResponse[:readerExecutionMessages]

    end

    def test_missing_constraint_elements

        TestReaderMdJsonParent.setContacts
        hIn = Marshal::load(Marshal.dump(@@hIn))
        hIn.delete('useLimitation')
        hIn.delete('scope')
        hIn.delete('graphic')
        hIn.delete('reference')
        hIn.delete('releasability')
        hIn.delete('responsibleParty')
        hIn.delete('legalConstraint')
        hIn.delete('securityConstraint')
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal 'use', metadata[:type]
        assert_empty metadata[:useLimitation]
        assert_empty metadata[:scope]
        assert_empty metadata[:graphic]
        assert_empty metadata[:reference]
        assert_empty metadata[:releasability]
        assert_empty metadata[:responsibleParty]
        assert_empty metadata[:legalConstraint]
        assert_empty metadata[:securityConstraint]
        assert hResponse[:readerExecutionPass]
        assert_empty hResponse[:readerExecutionMessages]

    end

    def test_empty_constraint_object

        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack({}, hResponse)

        assert_nil metadata
        refute hResponse[:readerExecutionPass]
        refute_empty hResponse[:readerExecutionMessages]

    end

end
