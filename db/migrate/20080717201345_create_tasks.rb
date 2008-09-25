class CreateTasks < ActiveRecord::Migration
  
  class << self
    
    def up
      create_table :tasks do |t|
        t.integer :project_id, :null => false
        t.string  :name,       :null => false
        t.text    :notes,                      :limit => 2047
        t.boolean :original,   :null => false
        t.boolean :finished,   :null => false, :default => false
        t.integer :position
        
        t.timestamps
      end
      
      add_index :tasks, :project_id
      add_index :tasks, :name
      add_index :tasks, :original
      add_index :tasks, :finished
      add_index :tasks, :position
    end
    
    def down
      drop_table :tasks
    end
    
  end
  
end
