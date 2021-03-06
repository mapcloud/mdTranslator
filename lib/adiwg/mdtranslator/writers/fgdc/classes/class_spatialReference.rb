# FGDC <<Class>> SpatialReference
# FGDC CSDGM writer output in XML

# History:
#  Stan Smith 2017-12-29 original script

require_relative 'class_geographicResolution'
require_relative 'class_planarReference'
require_relative 'class_mapCoordinateInfo'
require_relative 'class_localSystem'
require_relative 'class_geodeticReference'
require_relative 'class_verticalDatum'

module ADIWG
   module Mdtranslator
      module Writers
         module Fgdc

            class SpatialReference

               def initialize(xml, hResponseObj)
                  @xml = xml
                  @hResponseObj = hResponseObj
               end

               def writeXML(hResourceInfo)

                  aRepTypes = hResourceInfo[:spatialRepresentationTypes]
                  aResolutions = hResourceInfo[:spatialResolutions]
                  aSpaceRefs = hResourceInfo[:spatialReferenceSystems]

                  # classes used
                  geoResClass = GeographicResolution.new(@xml, @hResponseObj)
                  planarClass = PlanarReference.new(@xml, @hResponseObj)
                  coordInfoClass = CoordinateInformation.new(@xml, @hResponseObj)
                  localClass = LocalSystem.new(@xml, @hResponseObj)
                  geodeticClass = GeodeticReference.new(@xml, @hResponseObj)
                  vDatumClass = VerticalDatum.new(@xml, @hResponseObj)

                  # spatial reference 4.1 (horizsys) - horizontal coordinate reference system (required)
                  # oneOf [geograph | planar | local]
                  @xml.tag!('horizsys') do

                     # horizontal reference 4.1.1 (geograph) - geographic resolution
                     # <- resourceInfo.spatialResolution[].geographicResolution (first)
                     aResolutions.each do |hSpaceRes|
                        unless hSpaceRes.empty?
                           if hSpaceRes[:geographicResolution]
                              unless hSpaceRes[:geographicResolution].empty?
                                 @xml.tag!('geograph') do
                                    geoResClass.writeXML(hSpaceRes[:geographicResolution])
                                 end
                                 break
                              end
                           end
                        end
                     end

                     # horizontal reference 4.1.2 (planar) - planar coordinate system []
                     # <- spatialReferences[].systemParameterSet.projection
                     aSpaceRefs.each do |hSpaceRef|
                        unless hSpaceRef[:systemParameterSet].empty?
                           if hSpaceRef[:systemParameterSet][:projection]
                              hProjection = hSpaceRef[:systemParameterSet][:projection]
                              unless hProjection.empty?
                                 @xml.tag!('planar') do
                                    planarClass.writeXML(hProjection)
                                 end
                              end
                           end
                        end
                     end
                     # horizontal reference 4.1.2.4 (planci) - planar coordinate information
                     coordInfoClass.writeXML(aRepTypes, aResolutions)

                     # horizontal reference 4.1.3 (local) - any rectangular coordinate system not aligned with surface of earth
                     # <- spatialReferences[].systemParameterSet.projection
                     aSpaceRefs.each do |hSpaceRef|
                        unless hSpaceRef[:systemParameterSet].empty?
                           if hSpaceRef[:systemParameterSet][:projection]
                              hProjection = hSpaceRef[:systemParameterSet][:projection]
                              unless hProjection.empty?
                                 if hProjection[:projection] == 'local'
                                    @xml.tag!('local') do
                                       localClass.writeXML(hProjection)
                                    end
                                 end
                              end
                           end
                        end
                     end

                     # horizontal reference 4.1.4 (geodetic) - parameters for shape of earth
                     # <- spatialReferences[].systemParameterSet.geodetic
                     aSpaceRefs.each do |hSpaceRef|
                        unless hSpaceRef[:systemParameterSet].empty?
                           if hSpaceRef[:systemParameterSet][:geodetic]
                              hGeodetic = hSpaceRef[:systemParameterSet][:geodetic]
                              unless hGeodetic.empty?
                                 @xml.tag!('geodetic') do
                                    geodeticClass.writeXML(hGeodetic)
                                 end
                              end
                           end
                        end
                     end

                  end

                  # vertical reference 4.2 (vertdef) - vertical coordinate reference system
                  # <- spatialReferences[].systemParameterSet.verticalDatum
                  # pass in the full spatial reference array,
                  # ... all vertical datum must be under same 'vertdef' tag
                  haveVertical = false
                  aSpaceRefs.each do |hSpaceRef|
                     unless hSpaceRef[:systemParameterSet].empty?
                        unless hSpaceRef[:systemParameterSet][:verticalDatum].empty?
                           haveVertical = true
                        end
                     end
                  end
                  if haveVertical
                     @xml.tag!('vertdef') do
                        vDatumClass.writeXML(aSpaceRefs)
                     end
                  end

               end # writeXML
            end # SpatialReference

         end
      end
   end
end
