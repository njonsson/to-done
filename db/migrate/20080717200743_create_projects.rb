class CreateProjects < ActiveRecord::Migration
  
  class << self
    
    def up
      create_table :projects do |t|
        t.string :name,     :null => false
        t.string :slug,     :null => false
        t.text   :notes,                   :limit => 2047
        t.date   :closed_on
        
        t.timestamps
      end
      
      add_index :projects, :name
      add_index :projects, :slug
      add_index :projects, :closed_on
    end
    
    def down
      drop_table :projects
    end
    
  end
  
end
