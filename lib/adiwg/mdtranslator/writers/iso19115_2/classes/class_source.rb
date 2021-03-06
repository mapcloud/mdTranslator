# ISO <<Class>> LI_Source
# 19115-2 writer output in XML

# History:
#   Stan Smith 2016-12-07 refactored for mdTranslator/mdJson 2.0
#   Stan Smith 2015-07-14 refactored to eliminate namespace globals $WriterNS and $IsoNS
#   Stan Smith 2015-07-14 refactored to make iso19110 independent of iso19115_2 classes
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (hResponseObj)
#   Stan Smith 2014-12-12 refactored to handle namespacing readers and writers
#   Stan Smith 2014-07-09 modify require statements to function in RubyGem structure
# 	Stan Smith 2013-11-20 original script.

require_relative 'class_fraction'
require_relative 'class_referenceSystem'
require_relative 'class_citation'
require_relative 'class_processStep'

module ADIWG
    module Mdtranslator
        module Writers
            module Iso19115_2

                class LI_Source

                    def initialize(xml, hResponseObj)
                        @xml = xml
                        @hResponseObj = hResponseObj
                    end

                    def writeXML(hSource)

                        # classes used
                        fractionClass =  MD_RepresentativeFraction.new(@xml, @hResponseObj)
                        systemClass =  MD_ReferenceSystem.new(@xml, @hResponseObj)
                        citationClass =  CI_Citation.new(@xml, @hResponseObj)
                        stepClass =  LI_ProcessStep.new(@xml, @hResponseObj)

                        @xml.tag!('gmd:LI_Source') do

                            # source - description
                            s = hSource[:description]
                            unless s.nil?
                                @xml.tag!('gmd:description') do
                                    @xml.tag!('gco:CharacterString', s)
                                end
                            end
                            if s.nil? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:description')
                            end

                            # source - scale denominator
                            hResolution = hSource[:spatialResolution]
                            unless hResolution[:scaleFactor].nil?
                                @xml.tag!('gmd:scaleDenominator') do
                                    fractionClass.writeXML(hResolution[:scaleFactor])
                                end
                            end
                            if hResolution[:scaleFactor].nil? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:scaleDenominator')
                            end

                            # source - reference system
                            hSystem = hSource[:referenceSystem]
                            unless hSystem.empty?
                                @xml.tag!('gmd:sourceReferenceSystem') do
                                    systemClass.writeXML(hSystem)
                                end
                            end
                            if hSystem.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:sourceReferenceSystem')
                            end

                            # source - citation
                            hCitation = hSource[:sourceCitation]
                            unless hCitation.empty?
                                @xml.tag!('gmd:sourceCitation') do
                                    citationClass.writeXML(hCitation)
                                end
                            end
                            if hCitation.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:sourceCitation')
                            end

                            # source - extent [] (not implemented)

                            # source - process step []
                            aSteps = hSource[:sourceSteps]
                            aSteps.each do |hStep|
                                @xml.tag!('gmd:sourceStep') do
                                    stepClass.writeXML(hStep)
                                end
                            end
                            if aSteps.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:sourceStep')
                            end

                        end # gmd:LI_Source tag
                    end # writeXML
                end # LI_Source class

            end
        end
    end
end
