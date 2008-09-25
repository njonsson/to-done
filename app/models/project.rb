# Defines Project.

require 'lib/acts_as_sluggable'

# Represents a project made up of Task objects.
class Project < ActiveRecord::Base
  
  include SearchNamedScope
  
  # Determines for will_paginate the number of records per page in the UI.
  def self.per_page
    7
  end
  
  acts_as_sluggable :name
  reserved_slugs << 'closed' # Conflicts with a collection GET route.
  
  has_many :tasks, :dependent => :destroy, :order => 'position'
  
  named_scope :closed, lambda { |closed|
    unless [true, false].include?(closed)
      raise ArgumentError, 'expected boolean'
    end
    {:conditions => 'closed_on IS ' + (closed ? 'NOT NULL' : 'NULL'),
     :order => 'closed_on DESC, name'}
  }
  
  validates_presence_of :name
  validates_length_of :name, :allow_blank => true, :maximum => 255
  validates_uniqueness_of :name, :allow_blank => true
  
  validates_length_of :notes, :allow_blank => true,
                              :maximum => 2047,
                              :message => 'are too long (maximum is %d characters)'
  
  attr_protected :closed_on
  
  # Sets closed_on to today's date, saves the record and returns +true+. Returns
  # +false+ if the project was already closed.
  def close!
    return false unless closed_on.blank?
    self.closed_on = Time.now.to_date
    save!
  end
  
  # Returns +false+ if _closed_on_ is blank, otherwise +true+.
  def closed?
    ! closed_on.blank?
  end
  
  # Returns the sum of the current estimates for all associated Task objects.
  def current_estimate
    roll_up_tasks tasks, :current_estimate
  end
  
  # Returns the sum of the original estimates for all associated Task objects
  # marked "original," i.e., work identified at the outset of the project rather
  # than later on.
  def original_estimate
    roll_up_tasks tasks.original(true), :original_estimate
  end
  
  # Returns the sum of the latest remaining for all associated Task objects.
  def remaining
    roll_up_tasks tasks, :remaining
  end
  
  # Sets closed_on to +nil+, saves the record and returns +true+. Returns
  # +false+ if the project was already open.
  def reopen!
    return false if closed_on.blank?
    self.closed_on = nil
    save!
  end
  
private
  
  def roll_up_tasks(tasks, attribute)
    tasks.inject(nil) do |total, task|
       value = task.send(attribute)
       if total || value
         (total || 0) + (value || 0)
       else
         nil
       end
    end
  end
  
end
