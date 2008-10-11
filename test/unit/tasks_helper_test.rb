require 'test_helper'

module TasksHelperTest
  
  class WithOneTask < ActiveSupport::TestCase
    
    include TasksHelper
    
    def setup
      @tasks = stub('Paginator', :length => 1,
                                 :next_page => nil,
                                 :previous_page => nil)
    end
    
    def test_should_return_false_when_sent_show_move_down_with_task_index_zero
      assert_equal false, show_move_down?(0)
    end
    
    def test_should_return_false_when_sent_show_move_up_with_task_index_zero
      assert_equal false, show_move_up?(0)
    end
    
  end
  
  class WithTwoTasksOnOnePage < ActiveSupport::TestCase
    
    include TasksHelper
    
    def setup
      @tasks = stub('Paginator', :length => 2,
                                 :next_page => nil,
                                 :previous_page => nil)
    end
    
    def test_should_return_true_when_sent_show_move_down_with_task_index_zero
      assert_equal true, show_move_down?(0)
    end
    
    def test_should_return_false_when_sent_show_move_up_with_task_index_zero
      assert_equal false, show_move_up?(0)
    end
    
    def test_should_return_false_when_sent_show_move_down_with_task_index_one
      assert_equal false, show_move_down?(1)
    end
    
    def test_should_return_true_when_sent_show_move_up_with_task_index_one
      assert_equal true, show_move_up?(1)
    end
    
  end
  
  module WithSixTasksOnThreePages
    
    class WhereFirstPageIsCurrent < ActiveSupport::TestCase
      
      include TasksHelper
      
      def setup
      @tasks = stub('Paginator', :length => 2,
                                 :next_page => :page_two,
                                 :previous_page => nil)
      end
      
      def test_should_return_true_when_sent_show_move_down_with_task_index_zero
        assert_equal true, show_move_down?(0)
      end
      
      def test_should_return_false_when_sent_show_move_up_with_task_index_zero
        assert_equal false, show_move_up?(0)
      end
      
      def test_should_return_true_when_sent_show_move_down_with_task_index_one
        assert_equal true, show_move_down?(1)
      end
      
      def test_should_return_true_when_sent_show_move_up_with_task_index_one
        assert_equal true, show_move_up?(1)
      end
      
    end
    
    class WhereSecondPageIsCurrent < ActiveSupport::TestCase
      
      include TasksHelper
      
      def setup
      @tasks = stub('Paginator', :length => 2,
                                 :next_page => :page_three,
                                 :previous_page => :page_one)
      end
      
      def test_should_return_true_when_sent_show_move_down_with_task_index_zero
        assert_equal true, show_move_down?(0)
      end
      
      def test_should_return_true_when_sent_show_move_up_with_task_index_zero
        assert_equal true, show_move_up?(0)
      end
      
      def test_should_return_true_when_sent_show_move_down_with_task_index_one
        assert_equal true, show_move_down?(1)
      end
      
      def test_should_return_true_when_sent_show_move_up_with_task_index_one
        assert_equal true, show_move_up?(1)
      end
      
    end
    
    class WhereThirdPageIsCurrent < ActiveSupport::TestCase
      
      include TasksHelper
      
      def setup
      @tasks = stub('Paginator', :length => 2,
                                 :next_page => nil,
                                 :previous_page => :page_two)
      end
      
      def test_should_return_true_when_sent_show_move_down_with_task_index_zero
        assert_equal true, show_move_down?(0)
      end
      
      def test_should_return_true_when_sent_show_move_up_with_task_index_zero
        assert_equal true, show_move_up?(0)
      end
      
      def test_should_return_false_when_sent_show_move_down_with_task_index_one
        assert_equal false, show_move_down?(1)
      end
      
      def test_should_return_true_when_sent_show_move_up_with_task_index_one
        assert_equal true, show_move_up?(1)
      end
      
    end
    
  end
  
end
