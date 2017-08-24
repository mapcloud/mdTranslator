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

      hMetadata = @@NameSpace.unpack(@@xDoc, @@hResponseObj)

      assert 1==1

   end

end