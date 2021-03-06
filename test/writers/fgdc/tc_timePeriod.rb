# MdTranslator - minitest of
# writers / fgdc / class_timePeriod

# History:
#  Stan Smith 2017-11-23 original script

require_relative 'fgdc_test_parent'
require_relative '../../helpers/mdJson_hash_objects'
require_relative '../../helpers/mdJson_hash_functions'

class TestWriterFgdcTimePeriod < TestWriterFGDCParent

   # instance classes needed in script
   TDClass = FgdcWriterTD.new

   # get expected results
   xExpect = TestWriterFGDCParent.get_xml('timePeriodResults')
   @@axExpect = xExpect.xpath('//timeperd')

   # build mdJson test file in hash
   mdHash = TDClass.base

   mdHash[:metadata][:resourceInfo][:timePeriod][:startDateTime] = '2017-11-23T10:42:50'
   mdHash[:metadata][:resourceInfo][:timePeriod][:endDateTime] = '2017-11-23T17:19:58'

   @@mdHash = mdHash

   def test_timePeriod_complete

      hReturn = TestWriterFGDCParent.get_complete(@@mdHash, 'timePeriod', './metadata/idinfo/timeperd')
      assert_equal hReturn[0], hReturn[1]

   end

   def test_timePeriod_missing_time

      # start/end date only
      expect = @@axExpect[1].to_s.squeeze(' ')

      hIn = Marshal::load(Marshal.dump(@@mdHash))
      hIn[:metadata][:resourceInfo][:timePeriod][:startDateTime] = '2016-11-23'
      hIn[:metadata][:resourceInfo][:timePeriod][:endDateTime] = '2017-11-23'

      hResponseObj = ADIWG::Mdtranslator.translate(
         file: hIn.to_json, reader: 'mdJson', writer: 'fgdc', showAllTags: true
      )

      xGot = Nokogiri::XML(hResponseObj[:writerOutput])
      got = xGot.xpath('./metadata/idinfo/timeperd').to_s.squeeze(' ')

      assert_equal expect, got

      # start dateTime only
      expect = @@axExpect[2].to_s.squeeze(' ')

      hIn = Marshal::load(Marshal.dump(@@mdHash))
      hIn[:metadata][:resourceInfo][:timePeriod][:startDateTime] = '2017-11-24T10:45:14.666'
      hIn[:metadata][:resourceInfo][:timePeriod].delete(:endDateTime)

      hResponseObj = ADIWG::Mdtranslator.translate(
         file: hIn.to_json, reader: 'mdJson', writer: 'fgdc', showAllTags: true
      )

      xGot = Nokogiri::XML(hResponseObj[:writerOutput])
      got = xGot.xpath('./metadata/idinfo/timeperd').to_s.squeeze(' ')

      assert_equal expect, got

      # start date only
      expect = @@axExpect[3].to_s.squeeze(' ')

      hIn = Marshal::load(Marshal.dump(@@mdHash))
      hIn[:metadata][:resourceInfo][:timePeriod][:startDateTime] = '2017-11-24'
      hIn[:metadata][:resourceInfo][:timePeriod].delete(:endDateTime)

      hResponseObj = ADIWG::Mdtranslator.translate(
         file: hIn.to_json, reader: 'mdJson', writer: 'fgdc', showAllTags: true
      )

      xGot = Nokogiri::XML(hResponseObj[:writerOutput])
      got = xGot.xpath('./metadata/idinfo/timeperd').to_s.squeeze(' ')

      assert_equal expect, got

      # end dateTime only
      expect = @@axExpect[4].to_s.squeeze(' ')

      hIn = Marshal::load(Marshal.dump(@@mdHash))
      hIn[:metadata][:resourceInfo][:timePeriod].delete(:startDateTime)
      hIn[:metadata][:resourceInfo][:timePeriod][:endDateTime] = '2017-11-24T10:48:17'

      hResponseObj = ADIWG::Mdtranslator.translate(
         file: hIn.to_json, reader: 'mdJson', writer: 'fgdc', showAllTags: true
      )

      xGot = Nokogiri::XML(hResponseObj[:writerOutput])
      got = xGot.xpath('./metadata/idinfo/timeperd').to_s.squeeze(' ')

      assert_equal expect, got

      # end date only
      expect = @@axExpect[5].to_s.squeeze(' ')

      hIn = Marshal::load(Marshal.dump(@@mdHash))
      hIn[:metadata][:resourceInfo][:timePeriod].delete(:startDateTime)
      hIn[:metadata][:resourceInfo][:timePeriod][:endDateTime] = '2017-11-24'

      hResponseObj = ADIWG::Mdtranslator.translate(
         file: hIn.to_json, reader: 'mdJson', writer: 'fgdc', showAllTags: true
      )

      xGot = Nokogiri::XML(hResponseObj[:writerOutput])
      got = xGot.xpath('./metadata/idinfo/timeperd').to_s.squeeze(' ')

      assert_equal expect, got

   end

end
