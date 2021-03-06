# MdTranslator - minitest of
# reader / mdJson / module_image

# History:
#   Stan Smith 2017-01-16 added parent class to run successfully within rake
#   Stan Smith 2016-10-17 refactored for mdJson 2.0
#   Stan Smith 2015-06-22 refactored setup after removal of globals
#   Stan Smith 2014-12-30 original script

require_relative 'mdjson_test_parent'
require 'adiwg/mdtranslator/readers/mdJson/modules/module_imageDescription'

class TestReaderMdJsonImageDescription < TestReaderMdJsonParent

    # set variables for test
    @@NameSpace = ADIWG::Mdtranslator::Readers::MdJson::ImageDescription
    aIn = TestReaderMdJsonParent.getJson('image.json')
    @@hIn = aIn['imageDescription'][0]

    def test_imageDescription_schema

        errors = TestReaderMdJsonParent.testSchema(@@hIn, 'imageDescription.json')
        assert_empty errors

    end

    def test_complete_imageDescription_object

        hIn = Marshal::load(Marshal.dump(@@hIn))
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal 9.9, metadata[:illuminationElevationAngle]
        assert_equal 9.9, metadata[:illuminationAzimuthAngle]
        assert_equal 'imagingCondition', metadata[:imagingCondition]
        refute_empty metadata[:imageQualityCode]
        assert_equal 9.9, metadata[:cloudCoverPercent]
        assert_equal 9, metadata[:compressionQuantity]
        assert metadata[:triangulationIndicator]
        assert metadata[:radiometricCalibrationAvailable]
        assert metadata[:cameraCalibrationAvailable]
        assert metadata[:filmDistortionAvailable]
        assert metadata[:lensDistortionAvailable]
        assert hResponse[:readerExecutionPass]
        assert_empty hResponse[:readerExecutionMessages]

    end

    def test_imageDescription_empty_elements

        hIn = Marshal::load(Marshal.dump(@@hIn))
        hIn['illuminationElevationAngle'] = ''
        hIn['illuminationAzimuthAngle'] = ''
        hIn['imagingCondition'] = ''
        hIn['imageQualityCode'] = {}
        hIn['cloudCoverPercent'] = ''
        hIn['compressionQuantity'] = ''
        hIn['triangulationIndicator'] = ''
        hIn['radiometricCalibrationAvailable'] = ''
        hIn['cameraCalibrationAvailable'] = ''
        hIn['filmDistortionAvailable'] = ''
        hIn['lensDistortionAvailable'] = ''
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_nil metadata[:illuminationElevationAngle]
        assert_nil metadata[:illuminationAzimuthAngle]
        assert_nil metadata[:imagingCondition]
        assert_empty metadata[:imageQualityCode]
        assert_nil metadata[:cloudCoverPercent]
        assert_nil metadata[:compressionQuantity]
        refute metadata[:triangulationIndicator]
        refute metadata[:radiometricCalibrationAvailable]
        refute metadata[:cameraCalibrationAvailable]
        refute metadata[:filmDistortionAvailable]
        refute metadata[:lensDistortionAvailable]
        assert hResponse[:readerExecutionPass]
        assert_empty hResponse[:readerExecutionMessages]

    end

    def test_imageDescription_missing_elements

        hIn = Marshal::load(Marshal.dump(@@hIn))
        hIn['nonElement'] = ''
        hIn.delete('illuminationElevationAngle')
        hIn.delete('illuminationAzimuthAngle')
        hIn.delete('imagingCondition')
        hIn.delete('imageQualityCode')
        hIn.delete('cloudCoverPercent')
        hIn.delete('compressionQuantity')
        hIn.delete('triangulationIndicator')
        hIn.delete('radiometricCalibrationAvailable')
        hIn.delete('cameraCalibrationAvailable')
        hIn.delete('filmDistortionAvailable')
        hIn.delete('lensDistortionAvailable')
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_nil metadata[:illuminationElevationAngle]
        assert_nil metadata[:illuminationAzimuthAngle]
        assert_nil metadata[:imagingCondition]
        assert_empty metadata[:imageQualityCode]
        assert_nil metadata[:cloudCoverPercent]
        assert_nil metadata[:compressionQuantity]
        refute metadata[:triangulationIndicator]
        refute metadata[:radiometricCalibrationAvailable]
        refute metadata[:cameraCalibrationAvailable]
        refute metadata[:filmDistortionAvailable]
        refute metadata[:lensDistortionAvailable]
        assert hResponse[:readerExecutionPass]
        assert_empty hResponse[:readerExecutionMessages]

    end

    def test_empty_imageDescription_object

        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack({}, hResponse)

        assert_nil metadata
        refute hResponse[:readerExecutionPass]
        refute_empty hResponse[:readerExecutionMessages]

    end

end
