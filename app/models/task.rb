# Defines Task.

require 'lib/validates_existence_of'

# Represents a to-do item that is part of a Project.
class Task < ActiveRecord::Base
  
  include SearchNamedScope
  
  # Determines for will_paginate the number of records per page in the UI.
  def self.per_page
    7
  end
  
  VALID_BOOLEANS = %w(true  false
                      True  False
                      TRUE  FALSE
                      t     f
                      T     F)     +
                     [true, false]
  
  acts_as_list :scope => 'project_id'
  
  belongs_to :project
  
  has_many :assessments, :dependent => :destroy, :order => 'assessed_on'
  
  named_scope :finished, lambda { |finished|
    unless [true, false].include?(finished)
      raise ArgumentError, 'expected boolean'
    end
    {:conditions => {:finished => finished},
     :order => 'project_id, position'}
  }
  named_scope :original, lambda { |original|
    unless [true, false].include?(original)
      raise ArgumentError, 'expected boolean'
    end
    {:conditions => {:original => original},
     :order => 'project_id, position'}
  }
  
  validates_presence_of :project_id
  validates_existence_of :project, :allow_blank => true
  
  validates_presence_of :name
  validates_length_of :name, :allow_blank => true, :maximum => 255
  validates_uniqueness_of :name, :allow_blank => true, :scope => 'project_id'
  
  validates_length_of :notes, :allow_blank => true, :maximum => 2047
  
  validates_inclusion_of :original, :in => VALID_BOOLEANS
  
  validates_inclusion_of :finished, :in => VALID_BOOLEANS
  
  validates_numericality_of :position, :allow_blank => true,
                                       :greater_than => 0,
                                       :only_integer => true
  validates_uniqueness_of :position, :allow_blank => true,
                                     :scope => 'project_id'
  
  attr_protected :project_id, :finished
  
  def current_estimate
    return nil unless (assessment = latest_assessment)
    assessment.estimate
  end
  
  # Returns Assessment#assessed_on for the latest Assessment, if remaining is
  # zero, otherwise +nil+.
  def finished_on
    return nil unless (assessment = latest_assessment)
    return nil if (assessment.remaining > 0)
    assessment.assessed_on
  end
  
  # Returns Assessment#assessed_on for the latest Assessment.
  def latest_assessment_on
    return nil unless (assessment = latest_assessment)
    assessment.assessed_on
  end
  
  def original_estimate
    return nil unless (assessment = earliest_assessment)
    assessment.estimate
  end
  
  def remaining
    return nil unless (assessment = latest_assessment)
    assessment.remaining
  end
  
private
  
  def earliest_assessment
    assessments.peek(:first).first
  end
  
  def latest_assessment
    assessments.peek(:last).last
  end
  
end
