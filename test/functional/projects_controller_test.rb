require 'test_helper'

module ProjectsControllerTest
  
  class GetIndex < ActionController::TestCase
    
    tests ProjectsController
    
    fixtures :projects
    
    def setup
      @projects = Project.closed(false).paginate(:page => nil)
    end
    
    def do_get
      get :index
    end
    
    def test_should_set_expected_projects
      do_get
      assert_equal @projects, assigns(:projects)
    end
    
    def test_should_set_final_to_false
      do_get
      assert_equal false, assigns(:final)
    end
    
    def test_should_not_change_project_count
      assert_difference('Project.count', 0) { do_get }
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
  
  class GetClosed < ActionController::TestCase
    
    tests ProjectsController
    
    fixtures :projects
    
    def setup
      @projects = Project.closed(true).paginate(:page => nil)
    end
    
    def do_get
      get :closed
    end
    
    def test_should_set_expected_projects
      do_get
      assert_equal @projects, assigns(:projects)
    end
    
    def test_should_set_final_to_true
      do_get
      assert_equal true, assigns(:final)
    end
    
    def test_should_not_change_project_count
      assert_difference('Project.count', 0) { do_get }
    end
    
    def test_should_not_set_flash
      do_get
      assert_equal({}, flash)
    end
    
    def test_should_respond_with_success
      do_get
      assert_response :success
    end
    
    def test_should_render_closed_template
      do_get
      assert_template 'closed'
    end
    
  end
  
  class GetNew < ActionController::TestCase
    
    tests ProjectsController
    
    fixtures :projects
    
    def do_get
      get :new
    end
    
    def test_should_set_project
      do_get
      assert_not_nil assigns(:project)
    end
    
    def test_should_not_change_project_count
      assert_difference('Project.count', 0) { do_get }
    end
    
    def test_should_not_set_flash
      do_get
      assert_equal({}, flash)
    end
    
    def test_should_respond_with_success
      do_get
      assert_response :success
    end
    
    def test_should_render_new_template
      do_get
      assert_template 'new'
    end
    
  end
  
  module PostCreate
    
    class Successful < ActionController::TestCase
      
      tests ProjectsController
      
      def do_post
        post :create, :project => {:name => 'foo', :notes => 'bar'}
        @project = Project.find(:first, :order => 'created_at DESC')
      end
      
      def test_should_increment_project_count
        assert_difference('Project.count', 1) { do_post }
      end
      
      def test_should_create_with_name_attribute_as_expected
        do_post
        assert_equal 'foo', @project.name
      end
      
      def test_should_create_with_notes_attribute_as_expected
        do_post
        assert_equal 'bar', @project.notes
      end
      
      def test_should_set_expected_flash
        do_post
        assert_equal({:notice => 'Project was created.',
                      :highlight_dom_id => "project_#{@project.id}"},
                     flash)
      end
      
      def test_should_redirect_to_projects_path
        do_post
        assert_redirected_to projects_path
      end
      
    end
    
    class Failed < ActionController::TestCase
      
      tests ProjectsController
      
      def do_post
        post :create, :project => {:name => 'a' * 256, :notes => 'bar'}
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_post }
      end
      
      def test_should_not_set_flash
        do_post
        assert_equal({}, flash)
      end
      
      def test_should_render_new_template
        do_post
        assert_template 'new'
      end
      
    end
    
  end
  
  module GetShow
    
    class BySlug < ActionController::TestCase
      
      tests ProjectsController
      
      fixtures :projects
      
      def setup
        @project = projects(:open1)
      end
      
      def do_get
        get :show, :id => @project.slug
      end
      
      def test_should_set_expected_project
        do_get
        assert_equal @project, assigns(:project)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_get }
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
    
    class ByFormattedId < ActionController::TestCase
      
      tests ProjectsController
      
      fixtures :projects
      
      def setup
        @project = projects(:open1)
      end
      
      def do_get
        get :show, :id => @project.formatted_id
      end
      
      def test_should_set_expected_project
        do_get
        assert_equal @project, assigns(:project)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_get }
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
  
  module GetEdit
    
    class BySlug < ActionController::TestCase
      
      tests ProjectsController
      
      fixtures :projects
      
      def setup
        @project = projects(:open1)
      end
      
      def do_get
        get :edit, :id => @project.slug
      end
      
      def test_should_set_expected_project
        do_get
        assert_equal @project, assigns(:project)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_get }
      end
      
      def test_should_not_set_flash
        do_get
        assert_equal({}, flash)
      end
      
      def test_should_respond_with_success
        do_get
        assert_response :success
      end
      
      def test_should_render_edit_template
        do_get
        assert_template 'edit'
      end
      
    end
    
    class ByFormattedId < ActionController::TestCase
      
      tests ProjectsController
      
      fixtures :projects
      
      def setup
        @project = projects(:open1)
      end
      
      def do_get
        get :edit, :id => @project.formatted_id
      end
      
      def test_should_set_expected_project
        do_get
        assert_equal @project, assigns(:project)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_get }
      end
      
      def test_should_not_set_flash
        do_get
        assert_equal({}, flash)
      end
      
      def test_should_respond_with_success
        do_get
        assert_response :success
      end
      
      def test_should_render_edit_template
        do_get
        assert_template 'edit'
      end
      
    end
    
  end
  
  module PutUpdate
    
    module BySlug
      
      class Successful < ActionController::TestCase
        
        tests ProjectsController
        
        fixtures :projects
        
        def setup
          @project = projects(:open1)
        end
        
        def do_put
          put :update, :id => @project.slug,
                       :project => {:name => 'foo', :notes => 'bar'}
          @project.reload
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_put }
        end
        
        def test_should_update_name_attribute_as_expected
          do_put
          assert_equal 'foo', @project.name
        end
        
        def test_should_update_notes_attribute_as_expected
          do_put
          assert_equal 'bar', @project.notes
        end
        
        def test_should_set_expected_flash_notice
          do_put
          assert_equal({:notice => 'Project was saved.'}, flash)
        end
        
        def test_should_redirect_to_expected_project_path
          do_put
          assert_redirected_to project_path(@project)
        end
        
      end
      
      class Failed < ActionController::TestCase
        
        tests ProjectsController
        
        fixtures :projects
        
        def setup
          @project      = projects(:open1)
          @name_before  = @project.name
          @notes_before = @project.notes
        end
        
        def do_put
          put :update, :id => @project.slug,
                       :project => {:name => 'a' * 256, :notes => 'bar'}
          @project.reload
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_put }
        end
        
        def test_should_not_change_name_attribute
          do_put
          assert_equal @name_before, @project.name
        end
        
        def test_should_not_change_notes_attribute
          do_put
          assert_equal @notes_before, @project.notes
        end
        
        def test_should_not_set_flash
          do_put
          assert_equal({}, flash)
        end
        
        def test_should_render_edit_template
          do_put
          assert_template 'edit'
        end
        
      end
      
    end
    
    module ByFormattedId
      
      class Successful < ActionController::TestCase
        
        tests ProjectsController
        
        fixtures :projects
        
        def setup
          @project = projects(:open1)
        end
        
        def do_put
          put :update, :id => @project.formatted_id,
                       :project => {:name => 'foo', :notes => 'bar'}
          @project.reload
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_put }
        end
        
        def test_should_update_name_attribute_as_expected
          do_put
          assert_equal 'foo', @project.name
        end
        
        def test_should_update_notes_attribute_as_expected
          do_put
          assert_equal 'bar', @project.notes
        end
        
        def test_should_set_expected_flash_notice
          do_put
          assert_equal({:notice => 'Project was saved.'}, flash)
        end
        
        def test_should_redirect_to_expected_project_path
          do_put
          assert_redirected_to project_path(@project)
        end
        
      end
      
      class Failed < ActionController::TestCase
        
        tests ProjectsController
        
        fixtures :projects
        
        def setup
          @project      = projects(:open1)
          @name_before  = @project.name
          @notes_before = @project.notes
        end
        
        def do_put
          put :update, :id => @project.formatted_id,
                       :project => {:name => 'a' * 256, :notes => 'bar'}
          @project.reload
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_put }
        end
        
        def test_should_not_change_name_attribute
          do_put
          assert_equal @name_before, @project.name
        end
        
        def test_should_not_change_notes_attribute
          do_put
          assert_equal @notes_before, @project.notes
        end
        
        def test_should_not_set_flash
          do_put
          assert_equal({}, flash)
        end
        
        def test_should_render_edit_template
          do_put
          assert_template 'edit'
        end
        
      end
      
    end
    
  end
  
  module PutClose
    
    module BySlug
      
      class ForOpenProject < ActionController::TestCase
        
        tests ProjectsController
        
        fixtures :projects
        
        def setup
          @project = projects(:open1)
        end
        
        def do_put
          put :close, :id => @project.slug
          @project.reload
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_put }
        end
        
        def test_should_set_closed_on_attribute
          do_put
          assert_not_nil @project.closed_on
        end
        
        def test_should_set_expected_flash_notice
          do_put
          assert_equal({:notice => 'Project was closed.'}, flash)
        end
        
        def test_should_redirect_to_expected_project_path
          do_put
          assert_redirected_to project_path(@project)
        end
        
      end
      
      class ForClosedProject < ActionController::TestCase
        
        tests ProjectsController
        
        fixtures :projects
        
        def setup
          @project          = projects(:closed1)
          @closed_on_before = @project.closed_on
        end
        
        def do_put
          put :close, :id => @project.slug
          @project.reload
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_put }
        end
        
        def test_should_not_change_closed_on_attribute
          do_put
          assert_equal @closed_on_before, @project.closed_on
        end
        
        def test_should_not_set_flash
          do_put
          assert_equal({}, flash)
        end
        
        def test_should_redirect_to_expected_project_path
          do_put
          assert_redirected_to project_path(@project)
        end
        
      end
      
    end
    
    module ByFormattedId
      
      class ForOpenProject < ActionController::TestCase
        
        tests ProjectsController
        
        fixtures :projects
        
        def setup
          @project = projects(:open1)
        end
        
        def do_put
          put :close, :id => @project.formatted_id
          @project.reload
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_put }
        end
        
        def test_should_set_closed_on_attribute
          do_put
          assert_not_nil @project.closed_on
        end
        
        def test_should_set_expected_flash_notice
          do_put
          assert_equal({:notice => 'Project was closed.'}, flash)
        end
        
        def test_should_redirect_to_expected_project_path
          do_put
          assert_redirected_to project_path(@project)
        end
        
      end
      
      class ForClosedProject < ActionController::TestCase
        
        tests ProjectsController
        
        fixtures :projects
        
        def setup
          @project          = projects(:closed1)
          @closed_on_before = @project.closed_on
        end
        
        def do_put
          put :close, :id => @project.formatted_id
          @project.reload
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_put }
        end
        
        def test_should_not_change_closed_on_attribute
          do_put
          assert_equal @closed_on_before, @project.closed_on
        end
        
        def test_should_not_set_flash
          do_put
          assert_equal({}, flash)
        end
        
        def test_should_redirect_to_expected_project_path
          do_put
          assert_redirected_to project_path(@project)
        end
        
      end
      
    end
    
  end
  
  module PutReopen
    
    module BySlug
      
      class ForClosedProject < ActionController::TestCase
        
        tests ProjectsController
        
        fixtures :projects
        
        def setup
          @project = projects(:closed1)
        end
        
        def do_put
          put :reopen, :id => @project.slug
          @project.reload
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_put }
        end
        
        def test_should_clear_closed_on_attribute
          do_put
          assert_nil @project.closed_on
        end
        
        def test_should_set_expected_flash_notice
          do_put
          assert_equal({:notice => 'Project was reopened.'}, flash)
        end
        
        def test_should_redirect_to_expected_project_path
          do_put
          assert_redirected_to project_path(@project)
        end
        
      end
      
      class ForOpenProject < ActionController::TestCase
        
        tests ProjectsController
        
        fixtures :projects
        
        def setup
          @project          = projects(:open1)
          @closed_on_before = @project.closed_on
        end
        
        def do_put
          put :reopen, :id => @project.slug
          @project.reload
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_put }
        end
        
        def test_should_not_change_closed_on_attribute
          do_put
          assert_equal @closed_on_before, @project.closed_on
        end
        
        def test_should_set_flash
          do_put
          assert_equal({}, flash)
        end
        
        def test_should_redirect_to_expected_project_path
          do_put
          assert_redirected_to project_path(@project)
        end
        
      end
      
    end
    
  end
  
  module DeleteDestroy
    
    class BySlug < ActionController::TestCase
      
      tests ProjectsController
      
      fixtures :projects, :tasks, :assessments
      
      def setup
        @project                 = projects(:both_increasing)
        @task_count_before       = @project.tasks.count
        @assessment_count_before = @project.tasks.inject(0) do |result, t|
          result + t.assessments.count
        end
      end
      
      def do_delete
        delete :destroy, :id => @project.slug
      end
      
      def test_should_decrement_project_count
        assert_difference('Project.count', -1) { do_delete }
      end
      
      def test_should_decrease_task_count_by_expected_amount
        assert_difference('Task.count', -@task_count_before) { do_delete }
      end
      
      def test_should_decrease_assessment_count_by_expected_amount
        assert_difference('Assessment.count', -@assessment_count_before) do
          do_delete
        end
      end
      
      def test_should_set_expected_flash_notice
        do_delete
        assert_equal({:notice => 'Project was deleted.'}, flash)
      end
      
      def test_should_redirect_to_projects_path
        do_delete
        assert_redirected_to projects_path
      end
      
    end
    
    class ByFormattedId < ActionController::TestCase
      
      tests ProjectsController
      
      fixtures :projects, :tasks, :assessments
      
      def setup
        @project                 = projects(:both_increasing)
        @task_count_before       = @project.tasks.count
        @assessment_count_before = @project.tasks.inject(0) do |result, t|
          result + t.assessments.count
        end
      end
      
      def do_delete
        delete :destroy, :id => @project.formatted_id
      end
      
      def test_should_decrement_project_count
        assert_difference('Project.count', -1) { do_delete }
      end
      
      def test_should_decrease_task_count_by_expected_amount
        assert_difference('Task.count', -@task_count_before) { do_delete }
      end
      
      def test_should_decrease_assessment_count_by_expected_amount
        assert_difference('Assessment.count', -@assessment_count_before) do
          do_delete
        end
      end
      
      def test_should_set_expected_flash_notice
        do_delete
        assert_equal({:notice => 'Project was deleted.'}, flash)
      end
      
      def test_should_redirect_to_projects_path
        do_delete
        assert_redirected_to projects_path
      end
      
    end
    
  end
  
end
