require 'test_helper'

module DashboardControllerTest
  
  class GetIndex < ActionController::TestCase
    
    tests DashboardController
    
    fixtures :projects, :tasks, :assessments
    
    def setup
      @tasks = Project.closed(false).collect do |project|
        project.tasks.finished(false).first
      end.compact
    end
    
    def do_get
      get :index
    end
    
    def test_should_set_expected_tasks
      do_get
      assert_equal @tasks, assigns(:tasks)
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
    
    def test_should_render_index_template
      do_get
      assert_template 'index'
    end
    
  end
  
end
