# Defines TasksHelper.

# Methods added to this helper will be available to all TasksController
# templates.
module TasksHelper
  
  # Returns +true+ if the specified _task_index_ refers to an element in @tasks
  # that can be demoted one place in its list.
  def show_move_down?(task_index)
    return true if @tasks.next_page
    task_index < (@tasks.length - 1)
  end
  
  # Returns +true+ if the specified _task_index_ refers to an element in @tasks
  # that can be promoted one place in its list.
  def show_move_up?(task_index)
    return true if @tasks.previous_page
    0 < task_index
  end
  
end
