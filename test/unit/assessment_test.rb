require 'test_helper'

module AssessmentTest
  
  module ClassMethods
    
    module NamedScopes
      
      module Peek
        
        class WithNil < ActiveSupport::TestCase
          
          def test_should_raise_argument_error
            assert_raise(ArgumentError) { Assessment.peek nil }
          end
          
        end
        
        class WithFirst < ActiveSupport::TestCase
          
          fixtures :projects, :tasks, :assessments
          
          def setup
            @assessments = Assessment.peek(:first)
          end
          
          def test_should_return_earliest_assessment
            expected_assessments = Assessment.find(:all, :limit => 1,
                                                         :order => 'assessed_on')
            assert_equal expected_assessments, @assessments
          end
          
        end
        
        class WithLast < ActiveSupport::TestCase
          
          fixtures :projects, :tasks, :assessments
          
          def setup
            @assessments = Assessment.peek(:last)
          end
          
          def test_should_return_earliest_assessment
            expected_assessments = Assessment.find(:all, :limit => 1,
                                                         :order => 'assessed_on DESC')
            assert_equal expected_assessments, @assessments
          end
          
        end
        
      end
      
    end
    
  end
  
  class ProtectedAttrs < ActiveSupport::TestCase
    
    def test_should_cover_task_id
      assert_nil Assessment.new(:task_id => 7).task_id
    end
    
    def test_should_cover_assessed_on
      assert_nil Assessment.new(:assessed_on => Time.now.to_date).assessed_on
    end
    
  end
  
  module InstanceMethods
    
    module Save
      
      class WhenRemainingIsGreaterThan0 < ActiveSupport::TestCase
        
        def setup
          Project.delete_all; Task.delete_all; Assessment.delete_all
          
          project = Project.create!(:name => 'project')
          @other_task = project.tasks.create!(:name => 'other task',
                                              :original => true)
          @task = project.tasks.create!(:name => 'task', :original => true)
        end
        
        def do_save
          @assessment = @task.assessments.build(:estimate => 1, :remaining => 1)
          @assessment.assessed_on = Time.now.to_date
          @assessment.save!
          @other_task.reload
          @task.reload
        end
        
        def test_should_start_with_an_unfinished_other_task
          assert_equal false, @other_task.finished?
        end
        
        def test_should_start_with_an_unfinished_task
          assert_equal false, @task.finished?
        end
        
        def test_should_not_call_create_or_update_without_transaction_outside_a_transaction
          Assessment.stubs :transaction # Does not yield.
          @assessment.expects(:create_or_update_without_transaction).never.returns true
          do_save
        end
        
        def test_should_not_call_update_finished_attribute_of_taskEXCLAMATION_outside_a_transaction
          Assessment.stubs :transaction # Does not yield.
          @assessment.expects(:update_finished_attribute_of_task!).never
          do_save
        end
        
        def test_should_not_mark_other_task_as_finished
          do_save
          assert_equal false, @other_task.finished?
        end
        
        def test_should_not_mark_task_as_finished
          do_save
          assert_equal false, @task.finished?
        end
        
      end
      
      class WhenRemainingIs0 < ActiveSupport::TestCase
        
        def setup
          Project.delete_all; Task.delete_all; Assessment.delete_all
          
          project = Project.create!(:name => 'project')
          @other_task = project.tasks.create!(:name => 'other task',
                                              :original => true)
          @task = project.tasks.create!(:name => 'task', :original => true)
        end
        
        def do_save
          @assessment = @task.assessments.build(:estimate => 1, :remaining => 0)
          @assessment.assessed_on = Time.now.to_date
          @assessment.save!
          @other_task.reload
          @task.reload
        end
        
        def test_should_start_with_an_unfinished_other_task
          assert_equal false, @other_task.finished?
        end
        
        def test_should_start_with_an_unfinished_task
          assert_equal false, @task.finished?
        end
        
        def test_should_not_call_create_or_update_without_transaction_outside_a_transaction
          Assessment.stubs :transaction # Does not yield.
          @assessment.expects(:create_or_update_without_transaction).never.returns true
          do_save
        end
        
        def test_should_not_call_update_finished_attribute_of_taskEXCLAMATION_outside_a_transaction
          Assessment.stubs :transaction # Does not yield.
          @assessment.expects(:update_finished_attribute_of_task!).never
          do_save
        end
        
        def test_should_not_mark_other_task_as_finished
          do_save
          assert_equal false, @other_task.finished?
        end
        
        def test_should_mark_task_as_finished
          do_save
          assert_equal true, @task.finished?
        end
        
      end
      
    end
    
    module Destroy
      
      class WhenRemainingIsGreaterThan0 < ActiveSupport::TestCase
        
        def setup
          Project.delete_all; Task.delete_all; Assessment.delete_all
          
          project = Project.create!(:name => 'project')
          @other_task = project.tasks.create!(:name => 'other task',
                                              :original => true)
          @task = project.tasks.create!(:name => 'task', :original => true)
          @assessment = @task.assessments.build(:estimate => 1, :remaining => 1)
          @assessment.assessed_on = Time.now.to_date
          @assessment.save!
          @other_task.reload
          @task.reload
        end
        
        def do_destroy
          @assessment.destroy
          @other_task.reload
          @task.reload
        end
        
        def test_should_start_with_an_unfinished_other_task
          assert_equal false, @other_task.finished?
        end
        
        def test_should_start_with_an_unfinished_task
          assert_equal false, @task.finished?
        end
        
        def test_should_not_call_destroy_without_transaction_outside_a_transaction
          Assessment.stubs :transaction # Does not yield.
          @assessment.expects(:destroy_without_transaction).never
          do_destroy
        end
        
        def test_should_not_call_update_finished_attribute_of_taskEXCLAMATION_outside_a_transaction
          Assessment.stubs :transaction # Does not yield.
          @assessment.expects(:update_finished_attribute_of_task!).never
          do_destroy
        end
        
        def test_should_not_mark_other_task_as_finished
          do_destroy
          assert_equal false, @other_task.finished?
        end
        
        def test_should_not_mark_task_as_finished
          do_destroy
          assert_equal false, @task.finished?
        end
        
      end
      
      class WhenRemainingIs0 < ActiveSupport::TestCase
        
        def setup
          Project.delete_all; Task.delete_all; Assessment.delete_all
          
          project = Project.create!(:name => 'project')
          @other_task = project.tasks.create!(:name => 'other task',
                                              :original => true)
          @task = project.tasks.create!(:name => 'task', :original => true)
          @assessment = @task.assessments.build(:estimate => 1, :remaining => 0)
          @assessment.assessed_on = Time.now.to_date
          @assessment.save!
          @other_task.reload
          @task.reload
        end
        
        def do_destroy
          @assessment.destroy
          @other_task.reload
          @task.reload
        end
        
        def test_should_start_with_an_unfinished_other_task
          assert_equal false, @other_task.finished?
        end
        
        def test_should_start_with_a_finished_task
          assert_equal true, @task.finished?
        end
        
        def test_should_not_call_destroy_without_transaction_outside_a_transaction
          Assessment.stubs :transaction # Does not yield.
          @assessment.expects(:destroy_without_transaction).never
          do_destroy
        end
        
        def test_should_not_call_update_finished_attribute_of_taskEXCLAMATION_outside_a_transaction
          Assessment.stubs :transaction # Does not yield.
          @assessment.expects(:update_finished_attribute_of_task!).never
          do_destroy
        end
        
        def test_should_not_mark_other_task_as_finished
          do_destroy
          assert_equal false, @other_task.finished?
        end
        
        def test_should_mark_task_as_unfinished
          do_destroy
          assert_equal false, @task.finished?
        end
        
      end
      
    end
    
  end
  
  class MissingTaskId < ActiveSupport::TestCase
    
    def setup
      @assessment = Assessment.new
    end
    
    def test_should_not_be_valid
      assert_equal false, @assessment.valid?
    end
    
    def test_should_have_presence_validation_error_on_task_id
      @assessment.valid?
      assert_equal "can't be blank", @assessment.errors.on(:task_id)
    end
    
  end
  
  class WithNonexistentTask < ActiveSupport::TestCase
    
    def setup
      @assessment = Assessment.new
      @assessment.task_id = -7
    end
    
    def test_should_not_be_valid
      assert_equal false, @assessment.valid?
    end
    
    def test_should_have_existence_validation_error_on_project_id
      @assessment.valid?
      assert_equal 'must be an existing task', @assessment.errors.on(:task)
    end
    
  end
  
  class MissingAssessedOn < ActiveSupport::TestCase
    
    def setup
      @assessment = Assessment.new
    end
    
    def test_should_not_be_valid
      assert_equal false, @assessment.valid?
    end
    
    def test_should_have_presence_validation_error_on_assessed_on
      @assessment.valid?
      assert_equal "can't be blank", @assessment.errors.on(:assessed_on)
    end
    
  end
  
  module WithNonuniqueAssessedOn
    
    class InSameTask < ActiveSupport::TestCase
      
      def setup
        Project.delete_all; Task.delete_all; Assessment.delete_all
        project = Project.create!(:name => 'project')
        task = project.tasks.create!(:name => 'task',
                                     :original => true,
                                     :position => 1)
        assessment1 = task.assessments.build(:estimate => 1, :remaining => 1)
        assessment1.assessed_on = 1.day.ago.to_date
        assessment1.save!
        @assessment = task.assessments.build(:estimate => 1, :remaining => 1)
        @assessment.assessed_on = 1.day.ago.to_date
      end
      
      def test_should_not_be_valid
        assert_equal false, @assessment.valid?
      end
      
      def test_should_have_uniqueness_validation_error_on_assessed_on
        @assessment.valid?
        assert_equal 'has already been taken',
                     @assessment.errors.on(:assessed_on)
      end
      
    end
    
    class InDifferentTask < ActiveSupport::TestCase
      
      def setup
        Project.delete_all; Task.delete_all; Assessment.delete_all
        
        project = Project.create!(:name => 'project')
        
        task1 = project.tasks.create!(:name => 'task 1',
                                      :original => true,
                                      :position => 1)
        task1_assessment = task1.assessments.build(:estimate => 1,
                                                   :remaining => 1)
        task1_assessment.assessed_on = 1.day.ago.to_date
        task1_assessment.save!
        
        task2 = project.tasks.create!(:name => 'task 2',
                                      :original => true,
                                      :position => 2)
        @assessment = task2.assessments.build(:estimate => 1, :remaining => 1)
        @assessment.assessed_on = 1.day.ago.to_date
      end
      
      def test_should_have_no_errors_on_assessed_on
        @assessment.valid?
        assert_nil @assessment.errors.on(:assessed_on)
      end
      
    end
    
  end
  
  class MissingEstimate < ActiveSupport::TestCase
    
    def setup
      @assessment = Assessment.new
    end
    
    def test_should_not_be_valid
      assert_equal false, @assessment.valid?
    end
    
    def test_should_have_presence_validation_error_on_estimate
      @assessment.valid?
      assert_equal "can't be blank", @assessment.errors.on(:estimate)
    end
    
  end
  
  module WithInvalidEstimate
    
    class Nonnumeric < ActiveSupport::TestCase
      
      def setup
        @assessment = Assessment.new(:estimate => 'foo')
      end
      
      def test_should_not_be_valid
        assert_equal false, @assessment.valid?
      end
      
      def test_should_have_numericality_error_on_estimate
        @assessment.valid?
        assert_equal 'is not a number', @assessment.errors.on(:estimate)
      end
      
    end
    
    class Noninteger < ActiveSupport::TestCase
      
      def setup
        @assessment = Assessment.new(:estimate => 7.77)
      end
      
      def test_should_not_be_valid
        assert_equal false, @assessment.valid?
      end
      
      def test_should_have_numericality_error_on_estimate
        @assessment.valid?
        assert_equal 'is not a number', @assessment.errors.on(:estimate)
      end
      
    end
    
  end
  
  class MissingRemaining < ActiveSupport::TestCase
    
    def setup
      @assessment = Assessment.new
    end
    
    def test_should_not_be_valid
      assert_equal false, @assessment.valid?
    end
    
    def test_should_have_presence_validation_error_on_remaining
      @assessment.valid?
      assert_equal "can't be blank", @assessment.errors.on(:remaining)
    end
    
  end
  
  module WithInvalidRemaining
    
    class Nonnumeric < ActiveSupport::TestCase
      
      def setup
        @assessment = Assessment.new(:remaining => 'foo')
      end
      
      def test_should_not_be_valid
        assert_equal false, @assessment.valid?
      end
      
      def test_should_have_numericality_error_on_remaining
        @assessment.valid?
        assert_equal 'is not a number', @assessment.errors.on(:remaining)
      end
      
    end
    
    class Noninteger < ActiveSupport::TestCase
      
      def setup
        @assessment = Assessment.new(:remaining => 7.77)
      end
      
      def test_should_not_be_valid
        assert_equal false, @assessment.valid?
      end
      
      def test_should_have_numericality_error_on_remaining
        @assessment.valid?
        assert_equal 'is not a number', @assessment.errors.on(:remaining)
      end
      
    end
    
  end
  
  class WithRemainingGreaterThanEstimate < ActiveSupport::TestCase
    
    def setup
      @assessment = Assessment.new(:estimate => 1, :remaining => 2)
    end
    
    def test_should_not_be_valid
      assert_equal false, @assessment.valid?
    end
    
    def test_should_have_numericality_error_on_base
      @assessment.valid?
      assert_equal "Assessment can't have more remaining than the estimate",
                   @assessment.errors.on_base
    end
    
  end
  
end
