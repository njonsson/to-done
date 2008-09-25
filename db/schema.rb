# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080717201813) do

  create_table "assessments", :force => true do |t|
    t.integer  "task_id",     :null => false
    t.date     "assessed_on", :null => false
    t.integer  "estimate",    :null => false
    t.integer  "remaining",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessments", ["assessed_on"], :name => "index_assessments_on_assessed_on"
  add_index "assessments", ["task_id"], :name => "index_assessments_on_task_id"

  create_table "projects", :force => true do |t|
    t.string   "name",                       :null => false
    t.string   "slug",                       :null => false
    t.text     "notes",      :limit => 2047
    t.date     "closed_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["closed_on"], :name => "index_projects_on_closed_on"
  add_index "projects", ["slug"], :name => "index_projects_on_slug"
  add_index "projects", ["name"], :name => "index_projects_on_name"

  create_table "tasks", :force => true do |t|
    t.integer  "project_id",                                    :null => false
    t.string   "name",                                          :null => false
    t.text     "notes",      :limit => 2047
    t.boolean  "original",                                      :null => false
    t.boolean  "finished",                   :default => false, :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["position"], :name => "index_tasks_on_position"
  add_index "tasks", ["finished"], :name => "index_tasks_on_finished"
  add_index "tasks", ["original"], :name => "index_tasks_on_original"
  add_index "tasks", ["name"], :name => "index_tasks_on_name"
  add_index "tasks", ["project_id"], :name => "index_tasks_on_project_id"

end
