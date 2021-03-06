# sbJson 1.0 writer

# History:
#  Stan Smith 2017-05-12 refactored for mdJson/mdTranslator 2.0
#  Josh Bradley original script

require 'jbuilder'
require_relative 'version'
require_relative 'sections/sbJson_sbJson'

module ADIWG
   module Mdtranslator
      module Writers
         module SbJson

            def self.startWriter(intObj, responseObj)
               @contacts = intObj[:contacts]

               # set output flag for null properties
               Jbuilder.ignore_nil(!responseObj[:writerShowTags])

               # set the format of the output file based on the writer specified
               responseObj[:writerOutputFormat] = 'json'
               responseObj[:writerVersion] = ADIWG::Mdtranslator::Writers::SbJson::VERSION

               # write the sbJson metadata record
               metadata = SbJson.build(intObj, responseObj)

               # set writer pass to true if no messages
               # false or warning state will be set by writer code
               responseObj[:writerPass] = true if responseObj[:writerMessages].empty?

               # encode the metadata target as JSON
               metadata.target!
            end

            # find contact in contact array and return the contact hash
            def self.get_contact_by_index(contactIndex)
               if @contacts[contactIndex]
                  return @contacts[contactIndex]
               end
               {}
            end

            # find contact in contact array and return the contact hash
            def self.get_contact_by_id(contactId)
               @contacts.each do |hContact|
                  if hContact[:contactId] == contactId
                     return hContact
                  end
               end
               {}
            end

            # ignore jBuilder object mapping when array is empty
            def self.json_map(collection = [], _class)
               if collection.nil? || collection.empty?
                  return nil
               else
                  collection.map { |item| _class.build(item).attributes! }
               end
            end

            # find all nested objects in 'obj' that contain the element 'ele'
            def self.nested_objs_by_element(obj, ele)
               aCollected = []
               obj.each do |key, value|
                  if key == ele.to_sym
                     aCollected << obj
                  elsif obj.is_a?(Array)
                     if key.respond_to?(:each)
                        aReturn = nested_objs_by_element(key, ele)
                        aCollected = aCollected.concat(aReturn) unless aReturn.empty?
                     end
                  elsif obj[key].respond_to?(:each)
                     aReturn = nested_objs_by_element(value, ele)
                     aCollected = aCollected.concat(aReturn) unless aReturn.empty?
                  end
               end
               aCollected
            end

         end
      end
   end
end
