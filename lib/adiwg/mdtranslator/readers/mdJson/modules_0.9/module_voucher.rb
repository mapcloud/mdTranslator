# unpack voucher
# Reader - ADIwg JSON V1 to internal data structure

# History:
# 	Stan Smith 2013-11-21 original script
#   Stan Smith 2014-07-07 resolve require statements using Mdtranslator.reader_module
#   Stan Smith 2014-12-15 refactored to handle namespacing readers and writers

require $ReaderNS.readerModule('module_responsibleParty')

module ADIWG
    module Mdtranslator
        module Readers
            module MdJson

                module Voucher

                    def self.unpack(hVoucher)

                        # instance classes needed in script
                        intMetadataClass = InternalMetadata.new
                        intTaxVoucher = intMetadataClass.newTaxonVoucher

                        # taxonomy voucher - specimen
                        if hVoucher.has_key?('specimen')
                            s = hVoucher['specimen']
                            if s != ''
                                intTaxVoucher[:specimen] = s
                            end
                        end

                        # taxonomy - repository - responsible party
                        if hVoucher.has_key?('repository')
                            hRepository = hVoucher['repository']
                            unless hRepository.empty?
                                intTaxVoucher[:repository] = $ReaderNS::ResponsibleParty.unpack(hRepository)
                            end
                        end

                        return intTaxVoucher

                    end

                end

            end
        end
    end
end
