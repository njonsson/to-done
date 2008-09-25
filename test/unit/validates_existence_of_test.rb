require 'test_helper'
require 'lib/validates_existence_of'

module ValidatesExistenceOfTest
  
  class ActiverecordBaseClass < ActiveSupport::TestCase
    
    def test_should_respond_to_validates_existence_of
      assert_respond_to ActiveRecord::Base, :validates_existence_of
    end
    
  end
  
  class AnyModelClass < ActiveSupport::TestCase
    
    include ValidatesExistenceOf::ClassMethods
    
    def setup
      stubs :validates_each
    end
    
    def test_should_call_validates_each_with_expected_args_when_sent_validates_existence_of_with_one_attr
      expects(:validates_each).with [:bar], :message => 'must be an existing %s',
                                            :on => :save
      validates_existence_of :bar
    end
    
    def test_should_call_validates_each_with_expected_args_when_sent_validates_existence_of_with_two_attrs
      expects(:validates_each).with [:bar, :baz], :message => 'must be an existing %s',
                                                  :on => :save
      validates_existence_of :bar, :baz
    end
    
    def test_should_call_validates_each_with_expected_args_when_sent_validates_existence_of_with_one_attr_and_class_name_option
      expects(:validates_each).with [:bar], :class_name => 'Baz',
                                            :message => 'must be an existing %s',
                                            :on => :save
      validates_existence_of :bar, :class_name => 'Baz'
    end
    
    def test_should_call_validates_each_with_expected_args_when_sent_validates_existence_of_with_one_attr_and_foreign_key_option
      expects(:validates_each).with [:bar], :foreign_key => 'neighborhood_bar_id',
                                            :message => 'must be an existing %s',
                                            :on => :save
      validates_existence_of :bar, :foreign_key => 'neighborhood_bar_id'
    end
    
    def test_should_call_validates_each_with_expected_args_when_sent_validates_existence_of_with_one_attr_and_message_option
      expects(:validates_each).with [:bar], :message => 'baz', :on => :save
      validates_existence_of :bar, :message => 'baz'
    end
    
    def test_should_call_validates_each_with_expected_args_when_sent_validates_existence_of_with_one_attr_and_on_option
      expects(:validates_each).with [:bar], :message => 'must be an existing %s',
                                            :on => :update
      validates_existence_of :bar, :on => :update
    end
    
  end
  
end
