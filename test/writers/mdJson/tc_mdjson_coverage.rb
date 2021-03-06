# mdJson 2.0 writer tests - coverage description

# History:
#   Stan Smith 2017-03-16 original script

require 'minitest/autorun'
require 'json'
require 'adiwg-mdtranslator'
require_relative 'mdjson_test_parent'

class TestWriterMdJsonCoverageDescription < TestWriterMdJsonParent

   # get input JSON for test
   @@jsonIn = TestWriterMdJsonParent.getJson('coverage.json')

   def test_schema_coverage

      hIn = JSON.parse(@@jsonIn)
      hTest = hIn['metadata']['resourceInfo']['coverageDescription'][0]
      errors = TestWriterMdJsonParent.testSchema(hTest, 'coverageDescription.json')
      assert_empty errors

   end

   def test_complete_coverage

      metadata = ADIWG::Mdtranslator.translate(
         file: @@jsonIn, reader: 'mdJson', validate: 'normal',
         writer: 'mdJson', showAllTags: false)

      expect = JSON.parse(@@jsonIn)
      expect = expect['metadata']['resourceInfo']['coverageDescription']
      got = JSON.parse(metadata[:writerOutput])
      got = got['metadata']['resourceInfo']['coverageDescription']

      assert_equal expect, got

   end

end
