require 'test_helper'

module SearchesControllerTest
  
  module GetShow
    
    class Normally < ActionController::TestCase
      
      tests SearchesController
      
      fixtures :projects, :tasks
      
      def do_get
        get :show, :q => 'open'
      end
      
      def test_should_set_search
        do_get
        assert_not_nil assigns(:search)
      end
      
      def test_should_set_search_with_expected_results
        do_get
        assert_equal Task.search('open') + Project.search('open'),
                     assigns(:search).results
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_get }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_get }
      end
      
      def test_should_not_change_assessment_count
        assert_difference('Assessment.count', 0) { do_get }
      end
      
      def test_should_not_set_flash
        do_get
        assert_equal({}, flash)
      end
      
      def test_should_respond_with_success
        do_get
        assert_response :success
      end
      
      def test_should_render_show_template
        do_get
        assert_template 'show'
      end
      
    end
    
    class ViaXmlHttpRequest < ActionController::TestCase
      
      tests SearchesController
      
      fixtures :projects, :tasks
      
      def do_get
        xhr :get, :show, :q => 'open'
      end
      
      def test_should_set_search
        do_get
        assert_not_nil assigns(:search)
      end
      
      def test_should_set_search_with_expected_results
        do_get
        assert_equal Task.search('open') + Project.search('open'),
                     assigns(:search).results
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_get }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_get }
      end
      
      def test_should_not_change_assessment_count
        assert_difference('Assessment.count', 0) { do_get }
      end
      
      def test_should_not_set_flash
        do_get
        assert_equal({}, flash)
      end
      
      def test_should_respond_with_success
        do_get
        assert_response :success
      end
      
      def test_should_render_show_template
        do_get
        assert_template 'show'
      end
      
    end
    
  end
  
end
