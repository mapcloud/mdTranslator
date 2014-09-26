# unpack associated resource
# Reader - ADIwg JSON V1 to internal data structure

# History:
# 	Stan Smith 2014-05-02 original script
# 	Stan Smith 2014-05-28 added resource identifier section
# 	Stan Smith 2014-06-02 added resource metadata citation section
#   Stan Smith 2014-07-08 resolve require statements using Mdtranslator.reader_module
#   Stan Smith 2014-08-18 moved resourceIdentifier to citation module schema 0.6.0

require ADIWG::Mdtranslator.reader_module('module_citation', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_resourceIdentifier', $response[:readerVersionUsed])

module Adiwg_AssociatedResource

	def self.unpack(hAssocRes)

		# instance classes needed in script
		intMetadataClass = InternalMetadata.new
		intAssocRes = intMetadataClass.newAssociatedResource

		# associated resource - resource type - initiativeTypeCode
		if hAssocRes.has_key?('associationType')
			s = hAssocRes['associationType']
			if s != ''
				intAssocRes[:associationType] = s
			end
		end

		# associated resource - association type - associationTypeCode
		if hAssocRes.has_key?('resourceType')
			s = hAssocRes['resourceType']
			if s != ''
				intAssocRes[:resourceType] = s
			end
		end

		# associated resource - resource citation
		if hAssocRes.has_key?('resourceCitation')
			hCitation = hAssocRes['resourceCitation']
			unless hCitation.empty?
				intAssocRes[:resourceCitation] = Adiwg_Citation.unpack(hCitation)
			end
		end

		# associated resource - metadata citation
		if hAssocRes.has_key?('metadataCitation')
			hCitation = hAssocRes['metadataCitation']
			unless hCitation.empty?
				intAssocRes[:metadataCitation] = Adiwg_Citation.unpack(hCitation)
			end
		end

		return intAssocRes
	end

end
