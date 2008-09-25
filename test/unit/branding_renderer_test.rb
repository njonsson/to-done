require 'test_helper'

module BrandingRendererTest
  
  class WithNilUserAgent < ActiveSupport::TestCase
    
    def setup
      @branding_renderer = BrandingRenderer.new(nil)
    end
    
    def test_should_have_nil_user_agent
      assert_nil @branding_renderer.user_agent
    end
    
    def test_should_render_nil_application_name_for_body
      assert_nil @branding_renderer.application_name_for_body
    end
    
    def test_should_render_nil_application_name_for_title
      assert_nil @branding_renderer.application_name_for_title
    end
    
    def test_should_render_nil_finger_glyph_for_body
      assert_nil @branding_renderer.finger_glyph_for_body
    end
    
    def test_should_render_nil_finger_glyph_for_flash
      assert_nil @branding_renderer.finger_glyph_for_flash
    end
    
  end
  
  module WithUserAgentUbuntuLinux
    
    class Firefox < ActiveSupport::TestCase
      
      def setup
        @branding_renderer = BrandingRenderer.new('Mozilla/5.0 '          +
                                                  '(X11; U; Linux i686; ' +
                                                  'en-US; rv:1.9b5) '     +
                                                  'Gecko/2008041514 '     +
                                                  'Firefox/3.0b5')
      end
      
      def test_should_have_expected_user_agent
        expected_user_agent = 'Mozilla/5.0 '                           +
                              '(X11; U; Linux i686; en-US; rv:1.9b5) ' +
                              'Gecko/2008041514 Firefox/3.0b5'
        assert_equal expected_user_agent, @branding_renderer.user_agent
      end
      
      def test_should_render_expected_application_name_for_body
        assert_equal 'To ☞ Done!', @branding_renderer.application_name_for_body
      end
      
      def test_should_render_expected_application_name_for_title
        assert_equal 'To ☞ Done!', @branding_renderer.application_name_for_title
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_default
        assert_equal '☞', @branding_renderer.finger_glyph_for_body
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_up
        assert_equal '☝', @branding_renderer.finger_glyph_for_body(:up)
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_right
        assert_equal '☞', @branding_renderer.finger_glyph_for_body(:right)
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_down
        assert_equal '☟', @branding_renderer.finger_glyph_for_body(:down)
      end
      
      def test_should_render_expected_finger_glyph_for_flash
        assert_equal '☞&nbsp;', @branding_renderer.finger_glyph_for_flash
      end
      
    end
    
  end
  
  module WithUserAgentOSX
    
    class Firefox < ActiveSupport::TestCase
      
      def setup
        @branding_renderer = BrandingRenderer.new('Mozilla/5.0 '          +
                                                  '(Macintosh; U; '       +
                                                  'Intel Mac OS X 10.5; ' +
                                                  'en-US; rv:1.9) '       +
                                                  'Gecko/2008061004 '     +
                                                  'Firefox/3.0')
      end
      
      def test_should_have_expected_user_agent
        expected_user_agent = 'Mozilla/5.0 '                         +
                              '(Macintosh; U; Intel Mac OS X 10.5; ' +
                              'en-US; rv:1.9) '                      +
                              'Gecko/2008061004 Firefox/3.0'
        assert_equal expected_user_agent, @branding_renderer.user_agent
      end
      
      def test_should_render_expected_application_name_for_body
        assert_equal 'To ☞ Done!', @branding_renderer.application_name_for_body
      end
      
      def test_should_render_expected_application_name_for_title
        assert_equal 'To ☞ Done!', @branding_renderer.application_name_for_title
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_default
        assert_equal '☞', @branding_renderer.finger_glyph_for_body
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_up
        assert_equal '☝', @branding_renderer.finger_glyph_for_body(:up)
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_right
        assert_equal '☞', @branding_renderer.finger_glyph_for_body(:right)
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_down
        assert_equal '☟', @branding_renderer.finger_glyph_for_body(:down)
      end
      
      def test_should_render_expected_finger_glyph_for_flash
        assert_equal '☞&nbsp;', @branding_renderer.finger_glyph_for_flash
      end
      
    end
    
    class Safari < ActiveSupport::TestCase
      
      def setup
        @branding_renderer = BrandingRenderer.new('Mozilla/5.0 '            +
                                                  '(Macintosh; U; '         +
                                                  'Intel Mac OS X 10_5_4; ' +
                                                  'en-us) '                 +
                                                  'AppleWebKit/525.18 '     +
                                                  '(KHTML, like Gecko) '    +
                                                  'Version/3.1.2 '          +
                                                  'Safari/525.20.1')
      end
      
      def test_should_have_expected_user_agent
        expected_user_agent = 'Mozilla/5.0 '                                  +
                              '(Macintosh; U; Intel Mac OS X 10_5_4; en-us) ' +
                              'AppleWebKit/525.18 (KHTML, like Gecko) '       +
                              'Version/3.1.2 Safari/525.20.1'
        assert_equal expected_user_agent, @branding_renderer.user_agent
      end
      
      def test_should_render_expected_application_name_for_body
        assert_equal 'To ☞ Done!', @branding_renderer.application_name_for_body
      end
      
      def test_should_render_expected_application_name_for_title
        assert_equal 'To ☞ Done!', @branding_renderer.application_name_for_title
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_default
        assert_equal '☞', @branding_renderer.finger_glyph_for_body
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_up
        assert_equal '☝', @branding_renderer.finger_glyph_for_body(:up)
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_right
        assert_equal '☞', @branding_renderer.finger_glyph_for_body(:right)
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_down
        assert_equal '☟', @branding_renderer.finger_glyph_for_body(:down)
      end
      
      def test_should_render_expected_finger_glyph_for_flash
        assert_equal '☞&nbsp;', @branding_renderer.finger_glyph_for_flash
      end
      
    end
    
  end
  
  module WithUserAgentWindows
    
    'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.2.149.29 Safari/525.13'
    
    class Chrome < ActiveSupport::TestCase
      
      def setup
        @branding_renderer = BrandingRenderer.new('Mozilla/5.0 '         +
                                                  '(Windows; U; '        +
                                                  'Windows NT 5.1; '     +
                                                  'en-US) '              +
                                                  'AppleWebKit/525.13 '  +
                                                  '(KHTML, like Gecko) ' +
                                                  'Chrome/0.2.149.29 '   +
                                                  'Safari/525.13')
      end
      
      def test_should_have_expected_user_agent
        expected_user_agent = 'Mozilla/5.0 '                            +
                              '(Windows; U; Windows NT 5.1; en-US) '    +
                              'AppleWebKit/525.13 (KHTML, like Gecko) ' +
                              'Chrome/0.2.149.29 Safari/525.13'
        assert_equal expected_user_agent, @branding_renderer.user_agent
      end
      
      def test_should_render_expected_application_name_for_body
        assert_equal 'To <span style="font-family: Wingdings;">F</span> Done!',
                     @branding_renderer.application_name_for_body
      end
      
      def test_should_render_expected_application_name_for_title
        assert_equal 'To &ndash;&rsaquo; Done!',
                     @branding_renderer.application_name_for_title
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_default
        assert_equal '<span style="font-family: Wingdings;">F</span>',
                     @branding_renderer.finger_glyph_for_body
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_up
        assert_equal '<span style="font-family: Wingdings;">G</span>',
                     @branding_renderer.finger_glyph_for_body(:up)
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_right
        assert_equal '<span style="font-family: Wingdings;">F</span>',
                     @branding_renderer.finger_glyph_for_body(:right)
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_down
        assert_equal '<span style="font-family: Wingdings;">H</span>',
                     @branding_renderer.finger_glyph_for_body(:down)
      end
      
      def test_should_render_expected_finger_glyph_for_flash
        assert_equal '<span style="font-family: Wingdings;">F</span>&nbsp;',
                     @branding_renderer.finger_glyph_for_flash
      end
      
    end
    
    class Firefox < ActiveSupport::TestCase
      
      def setup
        @branding_renderer = BrandingRenderer.new('Mozilla/5.0 '        +
                                                  '(Windows; U; '       +
                                                  'Windows NT 5.1; '    +
                                                  'en-US; rv:1.9.0.1) ' +
                                                  'Gecko/2008070208 '   +
                                                  'Firefox/3.0.1')
      end
      
      def test_should_have_expected_user_agent
        expected_user_agent = 'Mozilla/5.0 '                  +
                              '(Windows; U; Windows NT 5.1; ' +
                              'en-US; rv:1.9.0.1) '           +
                              'Gecko/2008070208 Firefox/3.0.1'
        assert_equal expected_user_agent, @branding_renderer.user_agent
      end
      
      def test_should_render_expected_application_name_for_body
        assert_equal 'To &rarr; Done!',
                     @branding_renderer.application_name_for_body
      end
      
      def test_should_render_expected_application_name_for_title
        assert_equal 'To &ndash;&rsaquo; Done!',
                     @branding_renderer.application_name_for_title
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_default
        assert_equal '&rarr;', @branding_renderer.finger_glyph_for_body
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_up
        assert_equal '&uarr;', @branding_renderer.finger_glyph_for_body(:up)
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_right
        assert_equal '&rarr;', @branding_renderer.finger_glyph_for_body(:right)
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_down
        assert_equal '&darr;', @branding_renderer.finger_glyph_for_body(:down)
      end
      
      def test_should_render_expected_finger_glyph_for_flash
        assert_nil @branding_renderer.finger_glyph_for_flash
      end
      
    end
    
    class InternetExplorer < ActiveSupport::TestCase
      
      def setup
        @branding_renderer = BrandingRenderer.new('Mozilla/4.0 '            +
                                                  '(compatible; MSIE 7.0; ' +
                                                  'Windows NT 5.1)')
      end
      
      def test_should_have_expected_user_agent
        expected_user_agent = 'Mozilla/4.0 ' +
                              '(compatible; MSIE 7.0; Windows NT 5.1)'
        assert_equal expected_user_agent, @branding_renderer.user_agent
      end
      
      def test_should_render_expected_application_name_for_body
        assert_equal 'To <span style="font-family: Wingdings;">F</span> Done!',
                     @branding_renderer.application_name_for_body
      end
      
      def test_should_render_expected_application_name_for_title
        assert_equal 'To &ndash;&rsaquo; Done!',
                     @branding_renderer.application_name_for_title
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_default
        assert_equal '<span style="font-family: Wingdings;">F</span>',
                     @branding_renderer.finger_glyph_for_body
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_up
        assert_equal '<span style="font-family: Wingdings;">G</span>',
                     @branding_renderer.finger_glyph_for_body(:up)
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_right
        assert_equal '<span style="font-family: Wingdings;">F</span>',
                     @branding_renderer.finger_glyph_for_body(:right)
      end
      
      def test_should_render_expected_finger_glyph_for_body_with_down
        assert_equal '<span style="font-family: Wingdings;">H</span>',
                     @branding_renderer.finger_glyph_for_body(:down)
      end
      
      def test_should_render_expected_finger_glyph_for_flash
        assert_equal '<span style="font-family: Wingdings;">F</span>&nbsp;',
                     @branding_renderer.finger_glyph_for_flash
      end
      
    end
    
  end
  
end
