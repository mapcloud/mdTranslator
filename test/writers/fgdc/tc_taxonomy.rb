# MdTranslator - minitest of
# writers / fgdc / class_taxonomy

# History:
#  Stan Smith 2017-12-12 original script

require_relative 'fgdc_test_parent'
require_relative '../../helpers/mdJson_hash_objects'
require_relative '../../helpers/mdJson_hash_functions'

class TestWriterFgdcTaxonomy < TestWriterFGDCParent

   # instance classes needed in script
   TDClass = FgdcWriterTD.new

   # build mdJson test file in hash
   mdHash = TDClass.base

   mdHash[:metadata][:resourceInfo][:taxonomy] = TDClass.taxonomy

   # contacts
   mdHash[:contact] << TDClass.build_person('CID002', 'person name two')

   # taxon keywords
   hKeyword2 = TDClass.build_keywords('fgdc taxonomy keywords','taxon')
   TDClass.add_keyword(hKeyword2, 'animals')
   TDClass.add_keyword(hKeyword2, 'vertebrates')
   TDClass.add_keyword(hKeyword2, 'birds')
   mdHash[:metadata][:resourceInfo][:keyword] << hKeyword2

   hKeyword3 = TDClass.build_keywords('fgdc taxonomy keywords two','taxon')
   TDClass.add_keyword(hKeyword3, 'plants')
   TDClass.add_keyword(hKeyword3, 'grasses')
   TDClass.add_keyword(hKeyword3, 'bamboo')
   mdHash[:metadata][:resourceInfo][:keyword] << hKeyword3

   # taxonomy
   hTaxonomy = mdHash[:metadata][:resourceInfo][:taxonomy]
   hTaxonomy[:taxonomicSystem] << TDClass.build_taxonSystem('taxonomic system two', 'CID001', 'modifications two')
   hTaxonomy[:identificationReference] = []
   hIdentifier1 = TDClass.build_identifier('identification reference')
   hIdentifier1[:authority] = TDClass.build_citation('taxonomic identification reference', 'CID001')
   hTaxonomy[:identificationReference] << hIdentifier1
   hIdentifier2 = TDClass.build_identifier('identification reference two')
   hIdentifier2[:authority] = TDClass.build_citation('taxonomic identification reference two', 'CID001')
   hTaxonomy[:identificationReference] << hIdentifier2
   hTaxonomy[:observer] << TDClass.build_responsibleParty('observer', ['CID001','CID002'])
   hTaxonomy[:voucher] << TDClass.build_taxonVoucher('specimen one', ['CID001'])
   hTaxonomy[:voucher] << TDClass.build_taxonVoucher('specimen two', ['CID002'])

   # taxonomic classification
   hLevel0 = hTaxonomy[:taxonomicClassification]
   hLevel0[:taxonomicSystemId] = 'ITIS-1234-1234-abcd'
   hLevel0[:taxonomicRank] = 'kingdom'
   hLevel0[:latinName] = 'animalia'
   hLevel0[:commonName] = ['animals']
   TDClass.add_taxonClass(hLevel0, 'subkingdom', 'bilateria')

   hLevel1 = hLevel0[:subClassification][0]
   TDClass.add_taxonClass(hLevel1, 'subfamily', 'anserinae')

   hLevel2 = hLevel1[:subClassification][0]
   TDClass.add_taxonClass(hLevel2, 'genus', 'branta')
   TDClass.add_taxonClass(hLevel2, 'genus', 'anser', ['brent geese'])

   hLevel20 = hLevel2[:subClassification][0]
   hLevel21 = hLevel2[:subClassification][1]
   TDClass.add_taxonClass(hLevel20, 'species', 'branta bernicla', ['brant goose','ganso de collar'])
   TDClass.add_taxonClass(hLevel21, 'species', 'albifrons')

   @@mdHash = mdHash

   def test_taxonomy_complete

      hReturn = TestWriterFGDCParent.get_complete(@@mdHash, 'taxonomy', './metadata/idinfo/taxonomy')
      assert_equal hReturn[0], hReturn[1]

   end

   def test_taxonomy_missing_keywords

      hIn = Marshal::load(Marshal.dump(@@mdHash))
      hIn[:metadata][:resourceInfo][:keyword].delete_at(1)
      hIn[:metadata][:resourceInfo][:keyword].delete_at(1)

      hResponseObj = ADIWG::Mdtranslator.translate(
         file: hIn.to_json, reader: 'mdJson', writer: 'fgdc', showAllTags: true
      )

      xMetadata = Nokogiri::XML(hResponseObj[:writerOutput])

      refute_empty xMetadata.to_s
      refute hResponseObj[:writerPass]
      assert_includes hResponseObj[:writerMessages], 'Taxonomy is missing keyword set'

   end

end
