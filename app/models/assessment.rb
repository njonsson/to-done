# Defines Assessment.

require 'lib/validates_existence_of'

# Represents a dated assessment of Task work status.
class Assessment < ActiveRecord::Base
  
  # Determines for will_paginate the number of records per page in the UI.
  def self.per_page
    7
  end
  
  belongs_to :task
  
  named_scope :peek, lambda { |which|
    options = {:limit => 1}
    return options.merge(:order => 'assessed_on')      if which == :first
    return options.merge(:order => 'assessed_on DESC') if which == :last
    raise ArgumentError, 'expected :first or :last'
  }
  
  validates_presence_of :task_id
  validates_existence_of :task, :allow_blank => true
  
  validates_presence_of :assessed_on
  validates_uniqueness_of :assessed_on, :allow_blank => true,
                                        :scope => 'task_id'
  
  validates_presence_of :estimate
  validates_numericality_of :estimate, :allow_blank => true,
                                       :only_integer => true,
                                       :greater_than_or_equal_to => 0
  
  validates_presence_of :remaining
  validates_numericality_of :remaining, :allow_blank => true,
                                        :only_integer => true,
                                        :greater_than_or_equal_to => 0
  
  validate :estimate_and_remaining_do_not_conflict
  
  attr_protected :task_id, :assessed_on
  
  after_save    :update_finished_attribute_of_task!
  after_destroy :update_finished_attribute_of_task!
  
private
  
  # Wraps ActiveRecord::Base#create_or_update and its callbacks in a transaction
  # so that Task#finished doesn't get out of synch with its assessments.
  def create_or_update_with_transaction
    Assessment.transaction do
      create_or_update_without_transaction
    end
  end
  alias_method_chain :create_or_update, :transaction
  
  # Wraps ActiveRecord::Base#destroy and its callbacks in a transaction so that
  # Task#finished doesn't get out of synch with its assessments.
  def destroy_with_transaction
    Assessment.transaction do
      destroy_without_transaction
    end
  end
  alias_method_chain :destroy, :transaction
  
  def estimate_and_remaining_do_not_conflict
    if estimate.blank? || remaining.blank? || (remaining <= estimate)
      return
    end
    errors.add_to_base "Assessment can't have more remaining than the estimate"
  end
  
  def update_finished_attribute_of_task!
    if (remaining = task.remaining)
      task.finished = (remaining <= 0)
    else
      task.finished = false
    end
    task.save!
  end
  
end
