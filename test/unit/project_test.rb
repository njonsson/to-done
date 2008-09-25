require 'test_helper'

module ProjectTest
  
  module ClassMethods
    
    class FindBySlugOrFormattedId < ActiveSupport::TestCase
      
      fixtures :projects
      
      def setup
        @project = projects(:open1)
      end
      
      def test_should_find_by_slug
        assert_equal @project,
                     Project.find_by_slug_or_formatted_id(@project.slug)
      end
      
      def test_should_find_by_formatted_id
        assert_equal @project,
                     Project.find_by_slug_or_formatted_id(@project.formatted_id)
      end
      
    end
    
    module NamedScopes
      
      module Closed
        
        class WithNil < ActiveSupport::TestCase
          
          def test_should_raise_argument_error
            assert_raise(ArgumentError) { Project.closed nil }
          end
          
        end
        
        class WithTrue < ActiveSupport::TestCase
          
          fixtures :projects
          
          def setup
            @projects = Project.closed(true)
          end
          
          def test_should_return_closed_projects
            expected_projects = [projects(:closed1),
                                 projects(:closed2),
                                 projects(:closed3)]
            assert_equal expected_projects, expected_projects & @projects
          end
          
          def test_should_not_return_open_projects
            unexpected_projects = [projects(:open1),
                                   projects(:open2),
                                   projects(:open3)]
            assert_equal [], unexpected_projects & @projects
          end
          
        end
        
        class WithFalse < ActiveSupport::TestCase
          
          fixtures :projects
          
          def setup
            @projects = Project.closed(false)
          end
          
          def test_should_return_open_projects
            expected_projects = [projects(:open1),
                                 projects(:open2),
                                 projects(:open3)]
            assert_equal expected_projects, expected_projects & @projects
          end
          
          def test_should_not_return_closed_projects
            unexpected_projects = [projects(:closed1),
                                   projects(:closed2),
                                   projects(:closed3)]
            assert_equal [], unexpected_projects & @projects
          end
          
        end
        
      end
      
    end
    
  end
  
  class ProtectedAttrs < ActiveSupport::TestCase
    
    def test_should_cover_closed_on
      assert_nil Project.new(:closed_on => Time.now.to_date).closed_on
    end
    
  end
  
  module InstanceMethods
    
    module CloseEXCLAMATION
      
      class WhenOpen < ActiveSupport::TestCase
        
        fixtures :projects
        
        def setup
          @project = projects(:open1)
        end
        
        def test_should_return_true
          assert_equal true, @project.close!
        end
        
        def test_should_set_closed_on_to_today
          today = Time.now.to_date
          assert_nil @project.closed_on
          @project.close!
          assert_equal today, @project.closed_on
        end
        
      end
      
      class WhenAlreadyClosed < ActiveSupport::TestCase
        
        fixtures :projects
        
        def setup
          @project          = projects(:closed1)
          @closed_on_before = @project.closed_on
        end
        
        def test_should_return_false
          assert_equal false, @project.close!
        end
        
        def test_should_not_change_closed_on
          today = Time.now.to_date
          assert_not_equal today,
                           @closed_on_before,
                           'Expected project fixture to be closed as of a different date'
          @project.close!
          assert_equal @closed_on_before, @project.closed_on
        end
        
      end
      
    end
    
    module ClosedQUESTION
      
      class WhenOpen < ActiveSupport::TestCase
        
        fixtures :projects
        
        def setup
          @project = projects(:open1)
        end
        
        def test_should_return_false
          assert_equal false, @project.closed?
        end
        
      end
      
      class WhenClosed < ActiveSupport::TestCase
        
        fixtures :projects
        
        def setup
          @project = projects(:closed1)
        end
        
        def test_should_return_true
          assert_equal true, @project.closed?
        end
        
      end
      
    end
    
    class Destroy < ActiveSupport::TestCase
      
      fixtures :projects, :tasks, :assessments
      
      def setup
        @project = projects(:open1)
      end
      
      def test_should_decrement_project_count
        assert_difference('Project.count', -1) { @project.destroy }
      end
      
      def test_should_decrease_task_count_by_expected_amount
        tasks_count = @project.tasks.count
        assert_difference('Task.count', -tasks_count) { @project.destroy }
      end
      
      def test_should_decrease_assessment_count_by_expected_amount
        assessments_count = @project.tasks.inject(0) do |result, t|
          result + t.assessments.count
        end
        assert_difference('Assessment.count', -assessments_count) do
          @project.destroy
        end
      end
      
    end
    
    module ReopenEXCLAMATION
      
      class WhenClosed < ActiveSupport::TestCase
        
        fixtures :projects
        
        def setup
          @project = projects(:closed1)
        end
        
        def test_should_return_true
          assert_equal true, @project.reopen!
        end
        
        def test_should_set_closed_on_to_nil
          assert_not_nil @project.closed_on,
                         'Expected project fixture to be a closed project'
          @project.reopen!
          assert_nil @project.closed_on
        end
        
      end
      
      class WhenAlreadyOpen < ActiveSupport::TestCase
        
        fixtures :projects
        
        def setup
          @project = projects(:open1)
        end
        
        def test_should_return_false
          assert_equal false, @project.reopen!
        end
        
        def test_should_not_change_closed_on
          assert_nil @project.closed_on,
                     'Expected project fixture to be an open project'
          @project.reopen!
          assert_nil @project.closed_on
        end
        
      end
    
    end
    
    module RollUpMethods
      
      class OnNoTasks < ActiveSupport::TestCase
        
        fixtures :projects, :tasks, :assessments
        
        def setup
          @project = projects(:no_tasks)
        end
        
        def test_current_estimate_should_be_nil
          assert_nil @project.current_estimate
        end
        
        def test_original_estimate_should_be_nil
          assert_nil @project.original_estimate
        end
        
        def test_remaining_should_be_nil
          assert_nil @project.remaining
        end
        
      end
      
      class OnUnassessedTasks < ActiveSupport::TestCase
        
        fixtures :projects, :tasks, :assessments
        
        def setup
          @project = projects(:unassessed_tasks)
        end
        
        def test_current_estimate_should_be_nil
          assert_nil @project.current_estimate
        end
        
        def test_original_estimate_should_be_nil
          assert_nil @project.original_estimate
        end
        
        def test_remaining_should_be_nil
          assert_nil @project.remaining
        end
        
      end
      
      class OnEstimateIncreasingFrom1To6 < ActiveSupport::TestCase
        
        fixtures :projects, :tasks, :assessments
        
        def setup
          @project = projects(:estimate_increasing_from_1_to_6)
        end
        
        def test_current_estimate_should_be_6
          assert_equal 6, @project.current_estimate
        end
        
        def test_original_estimate_should_be_1
          assert_equal 1, @project.original_estimate
        end
        
        def test_remaining_should_be_2
          assert_equal 2, @project.remaining
        end
        
      end
      
      class OnEstimateDecreasingFrom3To2 < ActiveSupport::TestCase
        
        fixtures :projects, :tasks, :assessments
        
        def setup
          @project = projects(:estimate_decreasing_from_3_to_2)
        end
        
        def test_current_estimate_should_be_2
          assert_equal 2, @project.current_estimate
        end
        
        def test_original_estimate_should_be_3
          assert_equal 3, @project.original_estimate
        end
        
        def test_remaining_should_be_2
          assert_equal 2, @project.remaining
        end
        
      end
      
      class OnBothIncreasing < ActiveSupport::TestCase
        
        fixtures :projects, :tasks, :assessments
        
        def setup
          @project = projects(:both_increasing)
        end
        
        def test_current_estimate_should_be_6
          assert_equal 6, @project.current_estimate
        end
        
        def test_original_estimate_should_be_1
          assert_equal 1, @project.original_estimate
        end
        
        def test_remaining_should_be_6
          assert_equal 6, @project.remaining
        end
        
      end
      
      class OnRemainingDecreasingFrom3To2 < ActiveSupport::TestCase
        
        fixtures :projects, :tasks, :assessments
        
        def setup
          @project = projects(:remaining_decreasing_from_3_to_2)
        end
        
        def test_current_estimate_should_be_6
          assert_equal 6, @project.current_estimate
        end
        
        def test_original_estimate_should_be_3
          assert_equal 3, @project.original_estimate
        end
        
        def test_remaining_should_be_2
          assert_equal 2, @project.remaining
        end
        
      end
    
    end
    
    module ToParam
      
      class New < ActiveSupport::TestCase
        
        def setup
          @project = Project.new(:name => 'Foo')
          @project.valid?
        end
        
        def test_should_return_nil
          assert_nil @project.to_param
        end
        
      end
      
      class WithNilName < ActiveSupport::TestCase
        
        def setup
          @project = Project.create(:name => 'Foo')
          @project.name = nil
          @project.valid?
        end
        
        def test_should_return_former_slug
          assert_equal 'foo', @project.to_param
        end
        
      end
      
      class WithOneWordName < ActiveSupport::TestCase
        
        def setup
          @project = Project.create(:name => 'Foo')
        end
        
        def test_should_return_name_with_expected_formatting
          assert_equal 'foo', @project.to_param
        end
        
      end
      
      class WithTwoWordName < ActiveSupport::TestCase
        
        def setup
          @project = Project.create(:name => 'Foo Bar')
        end
        
        def test_should_return_name_with_expected_formatting
          assert_equal 'foo-bar', @project.to_param
        end
        
      end
      
      class WithQuotedName < ActiveSupport::TestCase
        
        def setup
          @project = Project.create(:name => '"Foo"')
        end
        
        def test_should_return_name_with_expected_formatting
          assert_equal 'foo', @project.to_param
        end
        
      end
      
      class WithApostropheInName < ActiveSupport::TestCase
        
        def setup
          @project = Project.create(:name => "Hawai'i")
        end
        
        def test_should_return_name_with_expected_formatting
          assert_equal 'hawaii', @project.to_param
        end
      
      end
      
      class WithMultipleConsecutiveApostrophesInName < ActiveSupport::TestCase
        
        def setup
          @project = Project.create(:name => "Hawai''i")
        end
        
        def test_should_return_name_with_expected_formatting
          assert_equal 'hawai-i', @project.to_param
        end
        
      end
      
      class WithUnderscoresInName < ActiveSupport::TestCase
        
        def setup
          @project = Project.create(:name => '_this_is_a_test_')
        end
        
        def test_should_return_name_with_expected_formatting
          assert_equal 'this-is-a-test', @project.to_param
        end
        
      end
      
      class WithNonuniqueSlug < ActiveSupport::TestCase
        
        fixtures :projects
        
        def setup
          @project = Project.new(:name => projects(:open1).name.upcase)
        end
        
        def test_should_not_be_valid
          assert_equal false, @project.valid?
        end
        
        def test_should_have_uniqueness_validation_error_on_slug
          @project.valid?
          assert_equal 'prepared from name conflicts with that of another project',
                       @project.errors.on(:slug)
        end
        
      end
      
    end
    
  end
  
  class MissingName < ActiveSupport::TestCase
    
    def setup
      @project = Project.new
    end
    
    def test_should_not_be_valid
      assert_equal false, @project.valid?
    end
    
    def test_should_have_presence_validation_error_on_name
      @project.valid?
      assert_equal "can't be blank", @project.errors.on(:name)
    end
    
  end
  
  class WithLongName < ActiveSupport::TestCase
    
    def setup
      @project = Project.new(:name => 'a' * 256)
    end
    
    def test_should_not_be_valid
      assert_equal false, @project.valid?
    end
    
    def test_should_have_length_validation_error_on_name
      @project.valid?
      assert_equal 'is too long (maximum is 255 characters)',
                   @project.errors.on(:name)
    end
    
  end
  
  class WithNonuniqueName < ActiveSupport::TestCase
    
    fixtures :projects
    
    def setup
      @project = Project.new(:name => projects(:open1).name)
    end
    
    def test_should_not_be_valid
      assert_equal false, @project.valid?
    end
    
    def test_should_have_uniqueness_validation_error_on_name
      @project.valid?
      assert_equal 'has already been taken', @project.errors.on(:name)
    end
    
  end
  
  class WithLongNotes < ActiveSupport::TestCase
    
    def setup
      @project = Project.new(:notes => 'a' * 2048)
    end
    
    def test_should_not_be_valid
      assert_equal false, @project.valid?
    end
    
    def test_should_have_length_validation_error_on_notes
      @project.valid?
      assert_equal 'are too long (maximum is 2047 characters)',
                   @project.errors.on(:notes)
    end
    
  end
  
end
