# MdTranslator - minitest of
# readers / fgdc / module_metadata

# History:
#   Stan Smith 2017-08-14 original script

require 'adiwg/mdtranslator/readers/fgdc/modules/module_fgdc'
require_relative 'fgdc_test_parent'

class TestReaderFgdcFgdc < TestReaderFGDCParent

   @@NameSpace = ADIWG::Mdtranslator::Readers::Fgdc::Fgdc

   # read the FGDC file
   @@xDoc = TestReaderFGDCParent.get_XML('fgdc_fullRecord.xml')

   def test_metadata_complete

      hResponse = Marshal::load(Marshal.dump(@@hResponseObj))
      intObj = @@NameSpace.unpack(@@xDoc, hResponse)

      refute_empty intObj
      refute_empty intObj[:schema]
      assert_equal 'fgdc', intObj[:schema][:name]
      assert_equal 25, intObj[:contacts].length
      refute_empty intObj[:metadata]
      assert_equal 1, intObj[:dataDictionaries].length
      assert_empty intObj[:metadataRepositories]

      hMetadata = intObj[:metadata]
      refute_empty hMetadata[:metadataInfo]
      refute_empty hMetadata[:resourceInfo]
      assert_equal 1, hMetadata[:lineageInfo].length
      assert_equal 2, hMetadata[:distributorInfo].length
      assert_equal 2, hMetadata[:associatedResources].length
      assert_empty hMetadata[:additionalDocuments]

   end

end
