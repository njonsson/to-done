class CreateAssessments < ActiveRecord::Migration
  
  class << self
    
    def up
      create_table :assessments do |t|
        t.integer  :task_id,     :null => false
        t.date     :assessed_on, :null => false
        t.integer  :estimate,    :null => false
        t.integer  :remaining,   :null => false
        
        t.timestamps
      end
      
      add_index :assessments, :task_id
      add_index :assessments, :assessed_on
    end
    
    def down
      drop_table :assessments
    end
    
  end
  
end
