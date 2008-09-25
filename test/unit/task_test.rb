require 'test_helper'

module TaskTest
  
  module ClassMethods
    
    module NamedScopes
      
      module Finished
        
        class WithNil < ActiveSupport::TestCase
          
          def test_should_raise_argument_error
            assert_raise(ArgumentError) { Task.finished nil }
          end
          
        end
        
        class WithTrue < ActiveSupport::TestCase
          
          fixtures :projects, :tasks, :assessments
          
          def setup
            @tasks = Task.finished(true)
          end
          
          def test_should_return_finished_tasks
            expected_tasks = Task.find_all_by_finished(true,
                                                       :order => 'project_id, ' +
                                                                 'position')
            assert_equal expected_tasks, @tasks
          end
          
        end
        
        class WithFalse < ActiveSupport::TestCase
          
          fixtures :projects, :tasks, :assessments
          
          def setup
            @tasks = Task.finished(false)
          end
          
          def test_should_return_unfinished_tasks
            expected_tasks = Task.find_all_by_finished(false,
                                                       :order => 'project_id, ' +
                                                                 'position')
            assert_equal expected_tasks, @tasks
          end
          
        end
        
      end
      
      module Original
        
        class WithNil < ActiveSupport::TestCase
          
          def test_should_raise_argument_error
            assert_raise(ArgumentError) { Task.original nil }
          end
          
        end
        
        class WithTrue < ActiveSupport::TestCase
          
          fixtures :projects, :tasks
          
          def setup
            @tasks = Task.original(true)
          end
          
          def test_should_return_original_tasks
            expected_tasks = Task.find_all_by_original(true,
                                                       :order => 'project_id, ' +
                                                                 'position')
            assert_equal expected_tasks, @tasks
          end
          
        end
        
        class WithFalse < ActiveSupport::TestCase
          
          fixtures :projects, :tasks
          
          def setup
            @tasks = Task.original(false)
          end
          
          def test_should_return_non_original_tasks
            expected_tasks = Task.find_all_by_original(false,
                                                       :order => 'project_id, ' +
                                                                 'position')
            assert_equal expected_tasks, @tasks
          end
          
        end
        
      end
      
    end
    
  end
  
  class ProtectedAttrs < ActiveSupport::TestCase
    
    def test_should_cover_project_id
      assert_nil Task.new(:project_id => 7).project_id
    end
    
    def test_should_cover_finished
      default_value = Task.new.finished
      assert_equal default_value,
                   Task.new(:finished => ! default_value).finished
    end
    
  end
  
  module InstanceMethods
    
    class Destroy < ActiveSupport::TestCase
      
      fixtures :projects, :tasks, :assessments
      
      def setup
        @task = tasks(:open1_original1)
      end
      
      def test_should_decrement_task_count
        assert_difference('Task.count', -1) { @task.destroy }
      end
      
      def test_should_decrease_assessment_count_by_expected_amount
        assessments_count = @task.assessments.count
        assert_difference('Assessment.count', -assessments_count) do
          @task.destroy
        end
      end
      
    end
    
    module RollUpMethods
      
      class OnUnassessedTask < ActiveSupport::TestCase
        
        fixtures :projects, :tasks, :assessments
        
        def setup
          @task = tasks(:unassessed_tasks1)
        end
        
        def test_current_estimate_should_be_nil
          assert_nil @task.current_estimate
        end
        
        def test_finished_on_should_be_nil
          assert_nil @task.finished_on
        end
        
        def test_latest_assessment_on_should_be_nil
          assert_nil @task.latest_assessment_on
        end
        
        def test_original_estimate_should_be_nil
          assert_nil @task.original_estimate
        end
        
        def test_remaining_should_be_nil
          assert_nil @task.remaining
        end
        
      end
      
      class OnEstimateIncreasingFrom1To3 < ActiveSupport::TestCase
        
        fixtures :projects, :tasks, :assessments
        
        def setup
          @task = tasks(:estimate_increasing_from_1_to_3_1)
        end
        
        def test_current_estimate_should_be_3
          assert_equal 3, @task.current_estimate
        end
        
        def test_finished_on_should_be_nil
          assert_nil @task.finished_on
        end
        
        def test_latest_assessment_on_should_be_2008_01_03
          assert_equal Date.parse('2008-01-03'), @task.latest_assessment_on
        end
        
        def test_original_estimate_should_be_1
          assert_equal 1, @task.original_estimate
        end
        
        def test_remaining_should_be_1
          assert_equal 1, @task.remaining
        end
        
      end
      
      class OnEstimateDecreasingFrom3To1 < ActiveSupport::TestCase
        
        fixtures :projects, :tasks, :assessments
        
        def setup
          @task = tasks(:estimate_decreasing_from_3_to_1_1)
        end
        
        def test_current_estimate_should_be_1
          assert_equal 1, @task.current_estimate
        end
        
        def test_finished_on_should_be_nil
          assert_nil @task.finished_on
        end
        
        def test_latest_assessment_on_should_be_2008_01_03
          assert_equal Date.parse('2008-01-03'), @task.latest_assessment_on
        end
        
        def test_original_estimate_should_be_3
          assert_equal 3, @task.original_estimate
        end
        
        def test_remaining_should_be_1
          assert_equal 1, @task.remaining
        end
        
      end
      
      class OnBothIncreasingFrom1To3 < ActiveSupport::TestCase
        
        fixtures :projects, :tasks, :assessments
        
        def setup
          @task = tasks(:both_increasing_from_1_to_3_1)
        end
        
        def test_current_estimate_should_be_3
          assert_equal 3, @task.current_estimate
        end
        
        def test_finished_on_should_be_nil
          assert_nil @task.finished_on
        end
        
        def test_latest_assessment_on_should_be_2008_01_03
          assert_equal Date.parse('2008-01-03'), @task.latest_assessment_on
        end
        
        def test_original_estimate_should_be_1
          assert_equal 1, @task.original_estimate
        end
        
        def test_remaining_should_be_3
          assert_equal 3, @task.remaining
        end
        
      end
      
      class OnRemainingDecreasingFrom3To1 < ActiveSupport::TestCase
        
        fixtures :projects, :tasks, :assessments
        
        def setup
          @task = tasks(:remaining_decreasing_from_3_to_1_1)
        end
        
        def test_current_estimate_should_be_3
          assert_equal 3, @task.current_estimate
        end
        
        def test_finished_on_should_be_nil
          assert_nil @task.finished_on
        end
        
        def test_latest_assessment_on_should_be_2008_01_03
          assert_equal Date.parse('2008-01-03'), @task.latest_assessment_on
        end
        
        def test_original_estimate_should_be_3
          assert_equal 3, @task.original_estimate
        end
        
        def test_remaining_should_be_1
          assert_equal 1, @task.remaining
        end
        
      end
      
      class OnRemainingDecreasingFrom2To0 < ActiveSupport::TestCase
        
        fixtures :projects, :tasks, :assessments
        
        def setup
          @task = tasks(:remaining_decreasing_from_2_to_0_1)
        end
        
        def test_current_estimate_should_be_2
          assert_equal 2, @task.current_estimate
        end
        
        def test_finished_on_should_be_2008_01_03
          assert_equal Date.parse('2008-01-03'), @task.finished_on
        end
        
        def test_latest_assessment_on_should_be_2008_01_03
          assert_equal Date.parse('2008-01-03'), @task.latest_assessment_on
        end
        
        def test_original_estimate_should_be_2
          assert_equal 2, @task.original_estimate
        end
        
        def test_remaining_should_be_0
          assert_equal 0, @task.remaining
        end
        
      end
    
    end
    
  end
  
  class MissingProjectId < ActiveSupport::TestCase
    
    def setup
      @task = Task.new
    end
    
    def test_should_not_be_valid
      assert_equal false, @task.valid?
    end
    
    def test_should_have_presence_validation_error_on_project_id
      @task.valid?
      assert_equal "can't be blank", @task.errors.on(:project_id)
    end
  end
  
  class WithNonexistentProject < ActiveSupport::TestCase
    
    def setup
      @task = Task.new
      @task.project_id = -7
    end
    
    def test_should_not_be_valid
      assert_equal false, @task.valid?
    end
    
    def test_should_have_existence_validation_error_on_project_id
      @task.valid?
      assert_equal 'must be an existing project', @task.errors.on(:project)
    end
    
  end
  
  class MissingName < ActiveSupport::TestCase
    
    def setup
      @task = Task.new
    end
    
    def test_should_not_be_valid
      assert_equal false, @task.valid?
    end
    
    def test_should_have_presence_validation_error_on_name
      @task.valid?
      assert_equal "can't be blank", @task.errors.on(:name)
    end
    
  end
  
  class WithLongName < ActiveSupport::TestCase
    
    def setup
      @task = Task.new(:name => 'a' * 256)
    end
    
    def test_should_not_be_valid
      assert_equal false, @task.valid?
    end
    
    def test_should_have_length_validation_error_on_name
      @task.valid?
      assert_equal 'is too long (maximum is 255 characters)',
                   @task.errors.on(:name)
    end
    
  end
  
  module WithNonuniqueName
    
    class InSameProject < ActiveSupport::TestCase
      
      fixtures :projects, :tasks
      
      def setup
        @task = Task.new(:project => projects(:open1),
                         :name => tasks(:open1_original1).name)
      end
      
      def test_should_not_be_valid
        assert_equal false, @task.valid?
      end
      
      def test_should_have_uniqueness_validation_error_on_name
        @task.valid?
        assert_equal 'has already been taken', @task.errors.on(:name)
      end
      
    end
    
    class InDifferentProject < ActiveSupport::TestCase
      
      fixtures :projects, :tasks
      
      def setup
        @task = Task.new(:project => projects(:open2),
                         :name => tasks(:open1_original1).name)
      end
      
      def test_should_have_no_errors_on_name
        @task.valid?
        assert_nil @task.errors.on(:name)
      end
      
    end
    
  end
  
  class WithLongNotes < ActiveSupport::TestCase
    
    def setup
      @task = Task.new(:notes => 'a' * 2048)
    end
    
    def test_should_not_be_valid
      assert_equal false, @task.valid?
    end
    
    def test_should_have_length_validation_error_on_notes
      @task.valid?
      assert_equal 'is too long (maximum is 2047 characters)',
                   @task.errors.on(:notes)
    end
    
  end
  
  module WithInvalidPosition
    
    class Nonnumeric < ActiveSupport::TestCase
      
      def setup
        @task = Task.new(:position => 'foo')
      end
      
      def test_should_not_be_valid
        assert_equal false, @task.valid?
      end
      
      def test_should_have_numericality_error_on_position
        @task.valid?
        assert_equal 'is not a number', @task.errors.on(:position)
      end
      
    end
    
    class Noninteger < ActiveSupport::TestCase
      
      def setup
        @task = Task.new(:position => 7.77)
      end
      
      def test_should_not_be_valid
        assert_equal false, @task.valid?
      end
      
      def test_should_have_numericality_error_on_position
        @task.valid?
        assert_equal 'is not a number', @task.errors.on(:position)
      end
      
    end
    
    class Zero < ActiveSupport::TestCase
      
      def setup
        @task = Task.new(:position => 0)
      end
      
      def test_should_not_be_valid
        assert_equal false, @task.valid?
      end
      
      def test_should_have_numericality_range_error_on_position
        @task.valid?
        assert_equal 'must be greater than 0', @task.errors.on(:position)
      end
      
    end
    
    module Nonunique
      
      class InSameProject < ActiveSupport::TestCase
        
        def setup
          Project.delete_all; Task.delete_all
          project = Project.create!(:name => 'project')
          task1 = project.tasks.create!(:name => 'task1',
                                        :original => true,
                                        :position => 1)
          @task = project.tasks.build(:name => 'task2',
                                      :original => true,
                                      :position => 1)
        end
        
        def test_should_not_be_valid
          assert_equal false, @task.valid?
        end
        
        def test_should_have_uniqueness_validation_error_on_position
          @task.valid?
          assert_equal 'has already been taken', @task.errors.on(:position)
        end
        
      end
      
      class InDifferentProject < ActiveSupport::TestCase
        
        def setup
          Project.delete_all; Task.delete_all
          
          project1 = Project.create!(:name => 'project1')
          project1_task = project1.tasks.create!(:name => 'project1 task',
                                                 :original => true,
                                                 :position => 1)
          
          project2 = Project.create!(:name => 'project2')
          @task = project2.tasks.build(:name => 'project2 task',
                                       :original => true,
                                       :position => 1)
        end
        
        def test_should_have_no_errors_on_position
          @task.valid?
          assert_nil @task.errors.on(:position)
        end
        
      end
      
    end
    
  end
  
end
