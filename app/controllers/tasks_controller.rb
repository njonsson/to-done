# Defines TasksController.

# Handles requests for Task resources.
class TasksController < ApplicationController
  
  before_filter :find_project, :only => [:index, :finished, :new, :create]
  before_filter :find_task,  :except => [:index, :finished, :new, :create]
  before_filter :find_assessments, :only => [:show, :assess]
  before_filter :find_reference_task, :only => [:move_above, :move_below]
  
  # Handles <tt>GET /projects/foo-bar/tasks</tt> requests.
  def index
    @tasks = @project.tasks.finished(false).paginate(:page => params[:page])
    @allow_reordering = (@tasks.total_entries > 1)
    @final = false
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # Handles <tt>GET /projects/foo-bar/tasks/finished</tt> requests.
  def finished
    @tasks = @project.tasks.finished(true).paginate(:page => params[:page])
    @allow_reordering = false
    @final = true
    
    respond_to do |format|
      format.html # finished.html.erb
    end
  end
  
  # Handles <tt>GET /projects/foo-bar/tasks/new</tt> requests.
  def new
    @task = Task.new
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # Handles <tt>POST /projects/foo-bar/tasks</tt> requests.
  def create
    @task = @project.tasks.build(params[:task])
    if @task.save
      @task.insert_at # The top of the list.
      respond_to do |format|
        format.html do
          flash[:notice] = 'Task was created.'
          flash[:highlight_dom_id] = dom_id(@task)
          redirect_to project_tasks_path(@project)
        end
      end
    else
      respond_to do |format|
        format.html { render :action => 'new' }
      end
    end
  end
  
  # Handles <tt>GET /tasks/123</tt> requests.
  def show
    @latest_assessment = @assessments.first
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  # Handles <tt>GET /tasks/123/edit</tt> requests.
  def edit
    @project = @task.project
    respond_to do |format|
      format.html # edit.html.erb
    end
  end
  
  # Handles <tt>PUT /tasks/123</tt> requests.
  def update
    @project = @task.project
    if @task.update_attributes(params[:task])
      respond_to do |format|
        format.html do
          flash[:notice] = 'Task was saved.'
          redirect_to task_path(@task)
        end
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
      end
    end
  end
  
  # Handles <tt>PUT /tasks/123/assess</tt> requests.
  def assess
    @latest_assessment = @task.assessments.find_or_initialize_by_assessed_on(Time.now.to_date)
    @latest_assessment.attributes = params[:latest_assessment]
    if @latest_assessment.save
      respond_to do |format|
        format.html do
          flash[:notice] = 'Task progress was recorded.'
          flash[:highlight_dom_id] = dom_id(@latest_assessment)
          redirect_to task_path(@task)
        end
      end
    else
      respond_to do |format|
        format.html { render :action => 'show' }
      end
    end
  end
  
  # Handles <tt>PUT /tasks/123/move_above?reference_id=456</tt> requests.
  def move_above
    if @reference_task.position < @task.position
      @task.insert_at @reference_task.position
      respond_to do |format|
        format.html do
          flash[:notice] = 'Task was moved up.'
          flash[:highlight_dom_id] = dom_id(@task)
        end
      end
    end
    respond_to do |format|
      format.html do
        redirect_to params[:redirect_to] || project_tasks_path(@task.project)
      end
    end
  end
  
  # Handles <tt>PUT /tasks/123/move_below?reference_id=456</tt> requests.
  def move_below
    if @task.position < @reference_task.position
      @task.insert_at @reference_task.position
      respond_to do |format|
        format.html do
          flash[:notice] = 'Task was moved down.'
          flash[:highlight_dom_id] = dom_id(@task)
        end
      end
    end
    respond_to do |format|
      format.html do
        redirect_to params[:redirect_to] || project_tasks_path(@task.project)
      end
    end
  end
  
  # Handles <tt>DELETE /tasks/123</tt> requests.
  def destroy
    @project = @task.project
    @task.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = 'Task was deleted.'
        redirect_to project_tasks_path(@project)
      end
    end
  end
  
private
  
  def find_assessments
    @assessments = @task.assessments.paginate(:page => params[:page],
                                              :order => 'assessed_on DESC')
  end
  
  def find_project
    @project = Project.find_by_slug_or_formatted_id(params[:project_id])
    @project || false
  end
  
  def find_reference_task
    @reference_task = @task.project.tasks.find(params[:reference_id])
  end
  
  def find_task
    @task = Task.find(params[:id])
  end
  
end
