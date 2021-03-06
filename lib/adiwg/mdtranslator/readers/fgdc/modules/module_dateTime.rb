# Reader - fgdc to internal data structure
# unpack fgdc metadata date

# History:
#  Stan Smith 2017-08-15 original script

require 'date'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/internal/module_dateTimeFun'
require_relative 'module_fgdc'

module ADIWG
   module Mdtranslator
      module Readers
         module Fgdc

            module DateTime

               def self.unpack(date, time, hResponseObj)

                  # instance classes needed in script
                  intMetadataClass = InternalMetadata.new
                  hDateTime = intMetadataClass.newDateTime

                  if date.nil? || date == ''
                     hResponseObj[:readerExecutionMessages] << 'date string is missing from dateTime'
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # remove invalid date and time input strings
                  unless date =~ /^[0-9\-]*$/
                     return nil
                  end
                  unless time =~ /^[0-9:]*$/
                     time = ''
                  end

                  # convert date from fgdc to iso format
                  year = date.byteslice(0,4)
                  month = date.byteslice(4,2)
                  day = date.byteslice(6,2)
                  month = '01' if month.nil? || month == ''
                  day = '01' if day.nil? || day == ''
                  dtIn = year + '-' + month + '-' + day

                  # add time element to date string
                  if time.empty?
                     dtIn = dtIn + 'T' + '00:00:00'
                  else
                     aScan = time.scan(/:/)
                     if aScan.empty?
                        hour = time.byteslice(0,2)
                        minute = time.byteslice(2,2)
                        second = time.byteslice(4,2)
                     else
                        aTime = time.split(':')
                        hour = aTime[0]
                        minute = aTime[1]
                        second = aTime[2]
                     end
                     minute = '00' if minute.nil? || minute == ''
                     second = '00' if second.nil? || second == ''
                     dtIn = dtIn + 'T' + hour + ':' + minute + ':' + second
                  end

                  # determine if date/time is 'universal time' or other
                  timeFlag = Fgdc.get_metadata_time_convention
                  timeFlag = 'local time' if timeFlag.nil? || timeFlag == ''

                  # add offset to date/time string
                  if timeFlag == 'universal time'
                     dtIn = dtIn + '+00:00'
                  else
                     timeOffset = Time.now.gmt_offset
                     aOffset = timeOffset.divmod(3600)
                     hourOff = aOffset[0]
                     minOff = aOffset[1] * 60
                     if hourOff >= 0
                        zone = '+' + '%02d' % hourOff + ':' + '%02d' % minOff
                     else
                        zone = '%03d' % hourOff + ':' + '%02d' % minOff
                     end
                     dtIn = dtIn + zone
                  end

                  # if dateTimeFromString fails, [0] = nil; [1] = 'ERROR'
                  aDateTimeReturn = AdiwgDateTimeFun.dateTimeFromString(dtIn)
                  if aDateTimeReturn[1] == 'ERROR'
                     hResponseObj[:readerExecutionMessages] << 'Date string is invalid'
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # if not 'universal time' change the offset to utc
                  dateTimeReturn = aDateTimeReturn[0]
                  if timeFlag == 'universal time'
                     utc = dateTimeReturn
                  else
                     utc = dateTimeReturn.new_offset(Rational(0,24))
                  end

                  # build internal dateTime object
                  hDateTime[:dateTime] = utc
                  hDateTime[:dateResolution] = aDateTimeReturn[1]

                  return hDateTime

               end

            end

         end
      end
   end
end
