# HTML writer
# responsible party

# History:
#  Stan Smith 2017-03-23 refactored for mdTranslator 2.0
#  Stan Smith 2015-07-16 refactored to remove global namespace $HtmlNS
# 	Stan Smith 2015-03-24 original script

require_relative 'html_extent'

module ADIWG
   module Mdtranslator
      module Writers
         module Html

            class Html_Responsibility
               def initialize(html)
                  @html = html
               end

               def writeHtml(hResponsibility)

                  # classes used
                  extentClass = Html_Extent.new(@html)

                  # responsibility - role parties
                  hResponsibility[:parties].each do |hParty|
                     hContact = Html_Document.getContact(hParty[:contactId])
                     @html.details do
                        @html.summary(hContact[:name], 'class' => 'h5')
                        @html.section(:class => 'block') do

                           # party - contact ID
                           @html.em('Contact ID: ')
                           @html.a(hContact[:contactId], 'href' => '#CID_'+hContact[:contactId])
                           @html.br

                           # party - contact type
                           unless hContact[:contactType].nil?
                              @html.em('Contact Type: ')
                              @html.text!(hContact[:contactType])
                              @html.br
                           end

                           if hContact[:isOrganization]
                              hParty[:organizationMembers].each do |hMember|
                                 hMemberContact = Html_Document.getContact(hMember[:contactId])
                                 @html.em('has Member: ')
                                 @html.a(hMemberContact[:name], 'href' => '#CID_'+hMember[:contactId])
                                 @html.br
                              end
                           else
                              hMemberContact = Html_Document.getContact(hContact[:contactId])
                              unless hMemberContact[:positionName].nil?
                                 @html.em('Position Name: ')
                                 @html.text!(hMemberContact[:positionName])
                                 @html.br
                              end
                           end

                        end
                     end
                  end

                  # responsibility - role extent [] {extent}
                  hResponsibility[:roleExtents].each do |hExtent|
                     @html.details do
                        @html.summary('Extent', {'class' => 'h5'})
                        @html.section(:class => 'block') do
                           extentClass.writeHtml(hExtent)
                        end
                     end
                  end

               end # writeHtml
            end # Html_Responsibility

         end
      end
   end
end
