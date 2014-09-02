#!/usr/bin/env ruby
# ADIwg mdTranslator - Thor CLI for mdtranslator

# History:
# 	Stan Smith 2014-07-15 original script

# uncomment next 2 lines during development to run from code (not gem) ....
lib = File.expand_path('lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'thor'
require 'adiwg-mdtranslator'

class Mdtranslatorcli < Thor

	# basic cli description
	desc 'translate [FILE]', %q{Pass file name or JSON plus parameters to mdtranslator translate}
	long_desc <<-LONGDESC
	    'mdtranslatorcli translate' provides command line access to the ADIWG metadata translator
 with options to select the input file reader, select writer output format, show empty tags
 in XML outputs, and choose level of validation for JSON inputs.
	LONGDESC
	# define cli options
	method_option :reader, :aliases => '-r', :desc => "Provide name of reader (default: 'adiwg')", :default => 'adiwg'
	method_option :writer, :aliases => '-w', :desc => "Provide name of writer (default: 'iso19115_2')", :default => 'iso19115_2'
	method_option :showtags, :aliases => '-s', :desc => "Show empty XML tags (default: 'true')", :type => :boolean, :default => true
	method_option :validation, :aliases => '-v', :desc => "Specify JSON validation level (default: 'none')", :enum => %w{none json schema}, :default => 'none'

	# accept command and options
	def translate(file)

		# test to see if file parameter is file or json
		if File.exist?(file)
			# read file
			my_file = File.open(file, 'r')
			readerObj = my_file.read
			my_file.close
		else
			readerObj = file
		end

		# for testing
		# puts 'My reader is: ' + options[:reader]
		# puts 'My writer is: ' + options[:writer]
		# puts 'My show tags is: ' + options[:showtags].to_s
		# puts 'My JSON validation level is: ' + options[:validation]
		# puts 'my JSON object is: ' + readerObj.to_s
		# require 'pp'
		# pp $LOAD_PATH

		# call mdtranslator
		metadata = ADIWG::Mdtranslator.translate(readerObj, options[:reader], options[:writer], options[:showtags], options[:validation])

		# for testing
		puts ''
		puts '---------------------=======================BEGIN=========================---------------------------'
		puts metadata.to_s
		puts '---------------------========================END==========================---------------------------'

		return metadata.to_s

	end

	Mdtranslatorcli.start(ARGV)

end