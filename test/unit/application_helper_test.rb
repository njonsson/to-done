require 'test_helper'

module ApplicationHelperTest
  
  module LinkToTasks
    
    class WithCountAndPath < ActiveSupport::TestCase
      
      include ApplicationHelper
      
      def setup
        stubs(:pluralize_with_pretty_zero).returns 'pluralize_with_pretty_zero'
        stubs(:link_to).returns 'link_to'
      end
      
      def call_link_to_tasks
        link_to_tasks 3, 'path'
      end
      
      def test_should_call_pluralize_with_pretty_zero_with_expected_arguments
        expects(:pluralize_with_pretty_zero).with(3, 'task').returns 'pluralize_with_pretty_zero'
        call_link_to_tasks
      end
      
      def test_should_call_link_to_with_expected_arguments
        expects(:link_to).with('pluralize_with_pretty_zero', 'path').returns 'link_to'
        call_link_to_tasks
      end
      
      def test_should_return_link_to
        assert_equal 'link_to', call_link_to_tasks
      end
      
    end
    
    class WithCountAndPathAndBefore < ActiveSupport::TestCase
      
      include ApplicationHelper
      
      def setup
        stubs(:pluralize_with_pretty_zero).returns 'pluralize_with_pretty_zero'
        stubs(:link_to).returns 'link_to'
      end
      
      def call_link_to_tasks
        link_to_tasks 3, 'path', :before => 'before'
      end
      
      def test_should_call_pluralize_with_pretty_zero_with_expected_arguments
        expects(:pluralize_with_pretty_zero).with(3, 'before task').returns 'pluralize_with_pretty_zero'
        call_link_to_tasks
      end
      
      def test_should_call_link_to_with_expected_arguments
        expects(:link_to).with('pluralize_with_pretty_zero', 'path').returns 'link_to'
        call_link_to_tasks
      end
      
      def test_should_return_link_to
        assert_equal 'link_to', call_link_to_tasks
      end
      
    end
    
    class WithCountAndPathAndAfter < ActiveSupport::TestCase
      
      include ApplicationHelper
      
      def setup
        stubs(:pluralize_with_pretty_zero).returns 'pluralize_with_pretty_zero'
        stubs(:link_to).returns 'link_to'
      end
      
      def call_link_to_tasks
        link_to_tasks 3, 'path', :after => 'after'
      end
      
      def test_should_call_pluralize_with_pretty_zero_with_expected_arguments
        expects(:pluralize_with_pretty_zero).with(3, 'task').returns 'pluralize_with_pretty_zero'
        call_link_to_tasks
      end
      
      def test_should_call_link_to_with_expected_arguments
        expects(:link_to).with('pluralize_with_pretty_zero after', 'path').returns 'link_to'
        call_link_to_tasks
      end
      
      def test_should_return_link_to
        assert_equal 'link_to', call_link_to_tasks
      end
      
    end
    
  end
  
  class PageTitleWithPagination < ActiveSupport::TestCase
    
    include ApplicationHelper
    
    def test_should_return_title_when_collection_has_no_pages
      collection = stub_everything(:total_pages => 0)
      assert_equal 'The Short List',
                   page_title_with_pagination('The Short List', collection)
    end
    
    def test_should_return_title_when_collection_has_one_page
      collection = stub_everything(:current_page => 1,
                                   :total_pages => 1)
      assert_equal 'The Medium List',
                   page_title_with_pagination('The Medium List', collection)
    end
    
    def test_should_return_title_with_page_when_collection_has_five_pages
      collection = stub_everything(:current_page => 3,
                                   :total_pages => 5)
      assert_equal 'The Long List (page 3)',
                   page_title_with_pagination('The Long List', collection)
    end
    
  end
  
end
