require 'test_helper'
require 'lib/acts_as_sluggable'

module ActsAsSluggableTest
  
  class ActiverecordBaseClass < ActiveSupport::TestCase
    
    def test_should_respond_to_acts_as_sluggable
      assert_respond_to ActiveRecord::Base, :acts_as_sluggable
    end
    
  end
  
  class ModelClassMissingSlugColumn < ActiveSupport::TestCase
    
    class Model < ActiveRecord::Base; end
    
    def setup
      Model.stubs(:columns).returns [stub_everything(:name => 'foo')]
    end
    
    def test_should_raise_runtime_error_when_sent_acts_as_sluggable
      assert_raise(RuntimeError) { Model.acts_as_sluggable :foo }
    end
    
  end
  
  class ModelClassMissingSourceColumn < ActiveSupport::TestCase
    
    class Model < ActiveRecord::Base; end
    
    def setup
      Model.stubs(:columns).returns [stub_everything(:name => 'slug')]
    end
    
    def test_should_raise_argument_error_when_sent_acts_as_sluggable
      assert_raise(ArgumentError) { Model.acts_as_sluggable :foo }
    end
    
  end
  
  class ModelClass < ActiveSupport::TestCase
    
    class Model < ActiveRecord::Base; end
    
    def setup
      Model.stubs(:columns).returns [stub_everything(:name => 'id',
                                                     :type => :integer),
                                     stub_everything(:name => 'slug',
                                                     :type => :string),
                                     stub_everything(:name => 'foo',
                                                     :type => :string)]
      Model.acts_as_sluggable :foo
      @model = Model.new
      @model.stubs(:id).returns 123
      @model.stubs(:slug).returns 'bar'
    end
    
    def test_should_return_slug_when_sent_to_param
      assert_equal 'bar', @model.to_param
    end
    
    def test_should_return_formatted_id_when_sent_formatted_id
      assert_equal '-123-', @model.formatted_id
    end
    
  end
  
  module ClassMethods
    
    class TextToSlug < ActiveSupport::TestCase
      
      def test_should_trim_leading_and_trailing_spaces
        assert_equal 'foo', ActsAsSluggable.text_to_slug(' foo ')
      end
      
      def test_should_trim_leading_and_trailing_hyphens
        assert_equal 'foo', ActsAsSluggable.text_to_slug('-foo-')
      end
      
      def test_should_delete_single_apostrophes_within_words
        assert_equal 'cant-always-get-watcha-want',
                     ActsAsSluggable.text_to_slug("can't always get w'atcha want")
      end
      
      def test_should_collapse_multiple_apostrophes_within_words_to_a_hyphen
        assert_equal 'foo-bar-baz-bat',
                     ActsAsSluggable.text_to_slug("foo''bar baz''bat")
      end
      
      def test_should_make_lowercase
        assert_equal 'foo-bar', ActsAsSluggable.text_to_slug('FOO Bar')
      end
      
      def test_should_not_affect_numerals
        assert_equal '123456', ActsAsSluggable.text_to_slug('123456')
      end
      
    end
    
  end
  
end
