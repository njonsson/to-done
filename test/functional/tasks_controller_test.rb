require 'test_helper'

module TasksControllerTest
  
  module GetIndex
    
    class ByProjectSlug < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks
      
      def setup
        @project = projects(:open1)
        @tasks   = @project.tasks.finished(false).paginate(:page => nil)
      end
      
      def do_get
        get :index, :project_id => @project.slug
      end
      
      def test_should_set_expected_project
        do_get
        assert_equal @project, assigns(:project)
      end
      
      def test_should_set_expected_tasks
        do_get
        assert_equal @tasks, assigns(:tasks)
      end
      
      def test_should_set_final_to_false
        do_get
        assert_equal false, assigns(:final)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_get }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_get }
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
    
    class ByProjectFormattedId < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks
      
      def setup
        @project = projects(:open1)
        @tasks   = @project.tasks.finished(false).paginate(:page => nil)
      end
      
      def do_get
        get :index, :project_id => @project.formatted_id
      end
      
      def test_should_set_expected_project
        do_get
        assert_equal @project, assigns(:project)
      end
      
      def test_should_set_expected_tasks
        do_get
        assert_equal @tasks, assigns(:tasks)
      end
      
      def test_should_set_final_to_false
        do_get
        assert_equal false, assigns(:final)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_get }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_get }
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
  
  module GetFinished
    
    class ByProjectSlug < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks
      
      def setup
        @project = projects(:open1)
        @tasks   = @project.tasks.finished(true).paginate(:page => nil)
      end
      
      def do_get
        get :finished, :project_id => @project.slug
      end
      
      def test_should_set_expected_project
        do_get
        assert_equal @project, assigns(:project)
      end
      
      def test_should_set_expected_tasks
        do_get
        assert_equal @tasks, assigns(:tasks)
      end
      
      def test_should_set_final_to_true
        do_get
        assert_equal true, assigns(:final)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_get }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_get }
      end
      
      def test_should_not_set_flash
        do_get
        assert_equal({}, flash)
      end
      
      def test_should_respond_with_success
        do_get
        assert_response :success
      end
      
      def test_should_render_finished_template
        do_get
        assert_template 'finished'
      end
      
    end
    
    class ByProjectFormattedId < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks
      
      def setup
        @project = projects(:open1)
        @tasks   = @project.tasks.finished(true).paginate(:page => nil)
      end
      
      def do_get
        get :finished, :project_id => @project.formatted_id
      end
      
      def test_should_set_expected_project
        do_get
        assert_equal @project, assigns(:project)
      end
      
      def test_should_set_expected_tasks
        do_get
        assert_equal @tasks, assigns(:tasks)
      end
      
      def test_should_set_final_to_true
        do_get
        assert_equal true, assigns(:final)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_get }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_get }
      end
      
      def test_should_not_set_flash
        do_get
        assert_equal({}, flash)
      end
      
      def test_should_respond_with_success
        do_get
        assert_response :success
      end
      
      def test_should_render_finished_template
        do_get
        assert_template 'finished'
      end
      
    end
    
  end
  
  module GetNew
    
    class ByProjectSlug < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks
      
      def setup
        @project = projects(:open1)
      end
      
      def do_get
        get :new, :project_id => @project.slug
      end
      
      def test_should_set_expected_project
        do_get
        assert_equal @project, assigns(:project)
      end
      
      def test_should_set_task
        do_get
        assert_not_nil assigns(:task)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_get }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_get }
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
    
    class ByProjectFormattedId < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks
      
      def setup
        @project = projects(:open1)
      end
      
      def do_get
        get :new, :project_id => @project.formatted_id
      end
      
      def test_should_set_expected_project
        do_get
        assert_equal @project, assigns(:project)
      end
      
      def test_should_set_task
        do_get
        assert_not_nil assigns(:task)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_get }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_get }
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
    
  end
  
  module PostCreate
    
    module ByProjectSlug
      
      class Successful < ActionController::TestCase
        
        tests TasksController
        
        fixtures :projects
        
        def setup
          @project = projects(:open1)
        end
        
        def do_post
          post :create, :project_id => @project.slug,
                        :task => {:name => 'foo',
                                  :notes => 'bar',
                                  :original => true}
          @task = Task.find(:first, :order => 'created_at DESC')
        end
        
        def test_should_set_expected_project
          do_post
          assert_equal @project, assigns(:project)
        end
        
        def test_should_set_task
          do_post
          assert_not_nil assigns(:task)
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_post }
        end
        
        def test_should_increment_task_count
          assert_difference('Task.count', 1) { do_post }
        end
        
        def test_should_create_with_name_attribute_as_expected
          do_post
          assert_equal 'foo', @task.name
        end
        
        def test_should_create_with_notes_attribute_as_expected
          do_post
          assert_equal 'bar', @task.notes
        end
        
        def test_should_create_with_original_attribute_as_expected
          do_post
          assert_equal true, @task.original?
        end
        
        def test_should_set_expected_flash
          do_post
          assert_equal({:notice => 'Task was created.',
                        :highlight_dom_id => "task_#{@task.id}"},
                       flash)
        end
        
        def test_should_redirect_to_expected_project_tasks_path
          do_post
          assert_redirected_to project_tasks_path(@project)
        end
        
      end
      
      class Failed < ActionController::TestCase
        
        tests TasksController
        
        fixtures :projects
        
        def setup
          @project = projects(:open1)
        end
        
        def do_post
          post :create, :project_id => @project.slug,
                        :task => {:name => 'a' * 256,
                                  :notes => 'bar',
                                  :original => true}
        end
        
        def test_should_set_expected_project
          do_post
          assert_equal @project, assigns(:project)
        end
        
        def test_should_set_task
          do_post
          assert_not_nil assigns(:task)
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_post }
        end
        
        def test_should_not_change_task_count
          assert_difference('Task.count', 0) { do_post }
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
    
    module ByProjectFormattedId
      
      class Successful < ActionController::TestCase
        
        tests TasksController
        
        fixtures :projects
        
        def setup
          @project = projects(:open1)
        end
        
        def do_post
          post :create, :project_id => @project.formatted_id,
                        :task => {:name => 'foo',
                                  :notes => 'bar',
                                  :original => true}
          @task = Task.find(:first, :order => 'created_at DESC')
        end
        
        def test_should_set_expected_project
          do_post
          assert_equal @project, assigns(:project)
        end
        
        def test_should_set_task
          do_post
          assert_not_nil assigns(:task)
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_post }
        end
        
        def test_should_increment_task_count
          assert_difference('Task.count', 1) { do_post }
        end
        
        def test_should_create_with_name_attribute_as_expected
          do_post
          assert_equal 'foo', @task.name
        end
        
        def test_should_create_with_notes_attribute_as_expected
          do_post
          assert_equal 'bar', @task.notes
        end
        
        def test_should_create_with_original_attribute_as_expected
          do_post
          assert_equal true, @task.original?
        end
        
        def test_should_set_expected_flash
          do_post
          assert_equal({:notice => 'Task was created.',
                        :highlight_dom_id => "task_#{@task.id}"},
                       flash)
        end
        
        def test_should_redirect_to_expected_project_tasks_path
          do_post
          assert_redirected_to project_tasks_path(@project)
        end
        
      end
      
      class Failed < ActionController::TestCase
        
        tests TasksController
        
        fixtures :projects
        
        def setup
          @project = projects(:open1)
        end
        
        def do_post
          post :create, :project_id => @project.formatted_id,
                        :task => {:name => 'a' * 256,
                                  :notes => 'bar',
                                  :original => true}
        end
        
        def test_should_set_expected_project
          do_post
          assert_equal @project, assigns(:project)
        end
        
        def test_should_set_task
          do_post
          assert_not_nil assigns(:task)
        end
        
        def test_should_not_change_project_count
          assert_difference('Project.count', 0) { do_post }
        end
        
        def test_should_not_change_task_count
          assert_difference('Task.count', 0) { do_post }
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
    
  end
  
  class GetShow < ActionController::TestCase
    
    tests TasksController
    
    fixtures :projects, :tasks, :assessments
    
    def setup
      @task              = tasks(:open1_original1)
      @assessments       = @task.assessments.paginate(:page => nil,
                                                      :order => 'assessed_on DESC')
      @latest_assessment = @assessments.first
    end
    
    def do_get
      get :show, :id => @task.id
    end
    
    def test_should_set_expected_task
      do_get
      assert_equal @task, assigns(:task)
    end
    
    def test_should_set_expected_assessments
      do_get
      assert_equal @assessments, assigns(:assessments)
    end
    
    def test_should_set_expected_latest_assessment
      do_get
      assert_equal @latest_assessment, assigns(:latest_assessment)
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
  
  class GetEdit < ActionController::TestCase
    
    tests TasksController
    
    fixtures :projects, :tasks, :assessments
    
    def setup
      @task = tasks(:open1_original1)
    end
    
    def do_get
      get :edit, :id => @task.id
    end
    
    def test_should_set_expected_task
      do_get
      assert_equal @task, assigns(:task)
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
    
    def test_should_render_edit_template
      do_get
      assert_template 'edit'
    end
    
  end
  
  module PutUpdate
    
    class Successful < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks
      
      def setup
        @task = tasks(:open1_original1)
      end
      
      def do_put
        put :update, :id => @task.id, :task => {:name => 'foo',
                                                :notes => 'bar',
                                                :original => false}
        @task.reload
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_put }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_put }
      end
      
      def test_should_update_name_attribute_as_expected
        do_put
        assert_equal 'foo', @task.name
      end
      
      def test_should_update_notes_attribute_as_expected
        do_put
        assert_equal 'bar', @task.notes
      end
      
      def test_should_update_original_attribute_as_expected
        do_put
        assert_equal false, @task.original?
      end
      
      def test_should_set_expected_flash_notice
        do_put
        assert_equal({:notice => 'Task was saved.'}, flash)
      end
      
      def test_should_redirect_to_expected_task_path
        do_put
        assert_redirected_to task_path(@task)
      end
      
    end
    
    class Failed < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks
      
      def setup
        @task            = tasks(:open1_original1)
        @name_before     = @task.name
        @notes_before    = @task.notes
        @original_before = @task.original?
      end
      
      def do_put
        put :update, :id => @task.id,
                     :task => {:name => 'a' * 256,
                               :notes => 'bar',
                               :original => false}
        @task.reload
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_put }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_put }
      end
      
      def test_should_not_change_name_attribute
        do_put
        assert_equal @name_before, @task.name
      end
      
      def test_should_not_change_notes_attribute
        do_put
        assert_equal @notes_before, @task.notes
      end
      
      def test_should_not_change_original_attribute
        do_put
        assert_equal @original_before, @task.original?
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
  
  module PutAssess
    
    class ForTaskWithoutAssessmentForToday < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks, :assessments
      
      def setup
        @task = tasks(:open1_original1)
        if (assessment =
            @task.assessments.find_by_assessed_on(Time.now.to_date))
          assessment.destroy
        end
        @assessments = @task.assessments.paginate(:page => nil,
                                                  :order => 'assessed_on DESC')
      end
      
      def do_put
        put :assess, :id => @task.id,
                     :latest_assessment => {:estimate => 373, :remaining => 212}
        @latest_assessment = @task.assessments.peek(:last).last
      end
      
      def test_should_set_expected_task
        do_put
        assert_equal @task, assigns(:task)
      end
    
      def test_should_set_expected_assessments
        do_put
        assert_equal @assessments, assigns(:assessments)
      end
    
      def test_should_set_expected_latest_assessment
        do_put
        assert_equal @latest_assessment, assigns(:latest_assessment)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_put }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_put }
      end
      
      def test_should_increase_assessment_count
        assert_difference('Assessment.count', 1) { do_put }
      end
      
      def test_should_update_task_current_estimate_as_expected
        do_put
        assert_equal 373, @task.current_estimate
      end
      
      def test_should_update_task_remaining_as_expected
        do_put
        assert_equal 212, @task.remaining
      end
      
      def test_should_set_expected_flash
        do_put
        assert_equal({:notice => 'Task progress was recorded.',
                      :highlight_dom_id => "assessment_#{@latest_assessment.id}"},
                     flash)
      end
      
      def test_should_redirect_to_expected_task_path
        do_put
        assert_redirected_to task_path(@task)
      end
      
    end
    
    class ForTaskWithAssessmentForToday < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks, :assessments
      
      def setup
        @task = tasks(:open1_original1)
        assessment = @task.assessments.find_or_initialize_by_assessed_on(Time.now.to_date)
        if assessment.new_record?
          assessment.estimate  = 654
          assessment.remaining = 321
          assessment.save!
        end
        @assessments = @task.assessments.paginate(:page => nil,
                                                  :order => 'assessed_on DESC')
      end
      
      def do_put
        put :assess, :id => @task.id,
                     :latest_assessment => {:estimate => 373, :remaining => 212}
        @latest_assessment = @task.assessments.peek(:last).last
      end
      
      def test_should_set_expected_task
        do_put
        assert_equal @task, assigns(:task)
      end
    
      def test_should_set_expected_assessments
        do_put
        assert_equal @assessments, assigns(:assessments)
      end
    
      def test_should_set_expected_latest_assessment
        do_put
        assert_equal @latest_assessment, assigns(:latest_assessment)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_put }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_put }
      end
      
      def test_should_not_change_assessment_count
        assert_difference('Assessment.count', 0) { do_put }
      end
      
      def test_should_update_task_current_estimate_as_expected
        do_put
        assert_equal 373, @task.current_estimate
      end
      
      def test_should_update_task_remaining_as_expected
        do_put
        assert_equal 212, @task.remaining
      end
      
      def test_should_set_expected_flash
        do_put
        assert_equal({:notice => 'Task progress was recorded.',
                      :highlight_dom_id => "assessment_#{@latest_assessment.id}"},
                     flash)
      end
      
      def test_should_redirect_to_expected_task_path
        do_put
        assert_redirected_to task_path(@task)
      end
      
    end
    
  end
  
  module PutMoveAbove
    
    class ForTaskBelowReferenceTask < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks
      
      def setup
        tasks = projects(:open1).tasks.finished(false)
        @reference_task, @task = tasks[-2..-1]
      end
      
      def do_put(redirect_to=nil)
        put :move_above, :id => @task.id,
                         :reference_id => @reference_task.id,
                         :redirect_to => redirect_to
        @task.reload
        @reference_task.reload
      end
      
      def test_should_start_with_task_below_reference_task
        assert @reference_task.position < @task.position
      end
      
      def test_should_set_expected_task
        do_put
        assert_equal @task, assigns(:task)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_put }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_put }
      end
      
      def test_should_move_task_above_reference_task
        do_put
        assert @task.position < @reference_task.position
      end
      
      def test_should_set_expected_flash
        do_put
        assert_equal({:notice => 'Task was moved up.',
                      :highlight_dom_id => "task_#{@task.id}"},
                     flash)
      end
      
      def test_should_redirect_to_expected_project_tasks_path
        do_put
        assert_redirected_to project_tasks_path(@task.project)
      end
      
      def test_should_redirect_to_expected_when_specified
        do_put 'http://www.rubyonrails.org/'
        assert_redirected_to 'http://www.rubyonrails.org/'
      end
      
    end
    
    class ForTaskAlreadyAboveReferenceTask < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks
      
      def setup
        tasks = projects(:open1).tasks.finished(false)
        @task, @reference_task = tasks[0..1]
      end
      
      def do_put(redirect_to=nil)
        put :move_above, :id => @task.id,
                         :reference_id => @reference_task.id,
                         :redirect_to => redirect_to
        @task.reload
        @reference_task.reload
      end
      
      def test_should_start_with_task_above_reference_task
        assert @task.position < @reference_task.position
      end
      
      def test_should_set_expected_task
        do_put
        assert_equal @task, assigns(:task)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_put }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_put }
      end
      
      def test_should_not_change_position_of_task
        assert_difference('@task.position', 0) { do_put }
      end
      
      def test_should_not_change_position_of_reference_task
        assert_difference('@reference_task.position', 0) { do_put }
      end
      
      def test_should_not_set_flash
        do_put
        assert_equal({}, flash)
      end
      
      def test_should_redirect_to_expected_project_tasks_path
        do_put
        assert_redirected_to project_tasks_path(@task.project)
      end
      
      def test_should_redirect_to_expected_when_specified
        do_put 'http://www.rubyonrails.org/'
        assert_redirected_to 'http://www.rubyonrails.org/'
      end
      
    end
    
  end
  
  module PutMoveBelow
    
    class ForTaskAboveReferenceTask < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks
      
      def setup
        tasks = projects(:open1).tasks.finished(false)
        @task, @reference_task = tasks[0..1]
      end
      
      def do_put(redirect_to=nil)
        put :move_below, :id => @task.id,
                         :reference_id => @reference_task.id,
                         :redirect_to => redirect_to
        @task.reload
        @reference_task.reload
      end
      
      def test_should_start_with_task_above_reference_task
        assert @task.position < @reference_task.position
      end
      
      def test_should_set_expected_task
        do_put
        assert_equal @task, assigns(:task)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_put }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_put }
      end
      
      def test_should_move_task_below_reference_task
        do_put
        assert @reference_task.position < @task.position
      end
      
      def test_should_set_expected_flash
        do_put
        assert_equal({:notice => 'Task was moved down.',
                      :highlight_dom_id => "task_#{@task.id}"},
                     flash)
      end
      
      def test_should_redirect_to_expected_project_tasks_path
        do_put
        assert_redirected_to project_tasks_path(@task.project)
      end
      
      def test_should_redirect_to_expected_when_specified
        do_put 'http://www.rubyonrails.org/'
        assert_redirected_to 'http://www.rubyonrails.org/'
      end
      
    end
    
    class ForTaskAlreadyBelowReferenceTask < ActionController::TestCase
      
      tests TasksController
      
      fixtures :projects, :tasks
      
      def setup
        tasks = projects(:open1).tasks.finished(false)
        @reference_task, @task = tasks[0..1]
      end
      
      def do_put(redirect_to=nil)
        put :move_below, :id => @task.id,
                         :reference_id => @reference_task.id,
                         :redirect_to => redirect_to
        @task.reload
        @reference_task.reload
      end
      
      def test_should_start_with_task_below_reference_task
        assert @reference_task.position < @task.position
      end
      
      def test_should_set_expected_task
        do_put
        assert_equal @task, assigns(:task)
      end
      
      def test_should_not_change_project_count
        assert_difference('Project.count', 0) { do_put }
      end
      
      def test_should_not_change_task_count
        assert_difference('Task.count', 0) { do_put }
      end
      
      def test_should_not_change_position_of_task
        assert_difference('@task.position', 0) { do_put }
      end
      
      def test_should_not_change_position_of_reference_task
        assert_difference('@reference_task.position', 0) { do_put }
      end
      
      def test_should_not_set_flash
        do_put
        assert_equal({}, flash)
      end
      
      def test_should_redirect_to_expected_project_tasks_path
        do_put
        assert_redirected_to project_tasks_path(@task.project)
      end
      
      def test_should_redirect_to_expected_when_specified
        do_put 'http://www.rubyonrails.org/'
        assert_redirected_to 'http://www.rubyonrails.org/'
      end
      
    end
    
  end
  
  class DeleteDestroy < ActionController::TestCase
    
    tests TasksController
    
    fixtures :projects, :tasks, :assessments
    
    def setup
      @project                 = projects(:both_increasing)
      @task                    = tasks(:both_increasing_from_1_to_3_1)
      @assessment_count_before = @task.assessments.count
    end
    
    def do_delete
      delete :destroy, :id => @task.id
    end
    
    def test_should_not_change_project_count
      assert_difference('Project.count', 0) { do_delete }
    end
    
    def test_should_decrement_task_count
      assert_difference('Task.count', -1) { do_delete }
    end
    
    def test_should_decrease_assessment_count_by_expected_amount
      assert_difference('Assessment.count', -@assessment_count_before) do
        do_delete
      end
    end
    
    def test_should_set_expected_flash_notice
      do_delete
      assert_equal({:notice => 'Task was deleted.'}, flash)
    end
    
    def test_should_redirect_to_expected_project_tasks_path
      do_delete
      assert_redirected_to project_tasks_path(@project)
    end
    
  end
  
end
