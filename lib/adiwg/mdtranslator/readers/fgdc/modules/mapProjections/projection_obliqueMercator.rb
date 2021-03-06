# Reader - fgdc to internal data structure
# unpack fgdc map projection - oblique mercator

# History:
#  Stan Smith 2017-10-17 original script

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'projection_common'

module ADIWG
   module Mdtranslator
      module Readers
         module Fgdc

            module ObliqueMercatorProjection

               def self.unpack(xParams, hProjection, hResponseObj)

                  # map projection 4.1.2.1.13 (obqmerc) - Oblique Mercator
                  unless xParams.empty?
                     paramCount = 0
                     hProjection[:projection] = 'obliqueMercator'
                     hProjection[:projectionName] = 'Oblique Mercator'

                     # -> ReferenceSystemParameters.projection.scaleFactorAtCenterLine
                     paramCount += ProjectionCommon.unpackSFCenter(xParams, hProjection, hResponseObj)

                     # -> oblique line azimuth ( azimuthAngle && azimuthMeasurePointLongitude )
                     # -> ReferenceSystemParameters.projection.azimuthAngle
                     # -> ReferenceSystemParameters.projection.azimuthMeasurePointLongitude
                     paramCount += ProjectionCommon.unpackObliqueLA(xParams, hProjection, hResponseObj)

                     # -> oblique line point 2( obliqueLinePoint{} )
                     paramCount += ProjectionCommon.unpackObliqueLP(xParams, hProjection, hResponseObj)

                     # -> ReferenceSystemParameters.projection.latitudeOfProjectionOrigin
                     paramCount += ProjectionCommon.unpackLatPO(xParams, hProjection, hResponseObj)

                     # -> ReferenceSystemParameters.projection.falseEasting
                     # -> ReferenceSystemParameters.projection.falseNorthing
                     paramCount += ProjectionCommon.unpackFalseNE(xParams, hProjection, hResponseObj)

                     # verify parameter count
                     if paramCount == 6
                        return hProjection
                     else
                        hResponseObj[:readerExecutionMessages] << 'oblique mercator projection is missing one or more parameters'
                        return nil
                     end
                  end

                  return nil

               end

            end

         end
      end
   end
end
