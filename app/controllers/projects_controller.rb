# Defines ProjectsController.

# Handles requests for Project resources.
class ProjectsController < ApplicationController
  
  before_filter :find_project, :except => [:index, :closed, :new, :create]
  
  # Handles <tt>GET /projects</tt> requests.
  def index
    @projects = Project.closed(false).paginate(:page => params[:page])
    @final = false
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # Handles <tt>GET /projects/closed</tt> requests.
  def closed
    @projects = Project.closed(true).paginate(:page => params[:page])
    @final = true
    
    respond_to do |format|
      format.html # closed.html.erb
    end
  end
  
  # Handles <tt>GET /projects/new</tt> requests.
  def new
    @project = Project.new
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # Handles <tt>POST /projects</tt> requests.
  def create
    @project = Project.new(params[:project])
    if @project.save
      respond_to do |format|
        format.html do
          flash[:notice] = 'Project was created.'
          flash[:highlight_dom_id] = dom_id(@project)
          redirect_to projects_path
        end
      end
    else
      respond_to do |format|
        format.html { render :action => 'new' }
      end
    end
  end
  
  # Handles <tt>GET /projects/foo-bar</tt> requests.
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  # Handles <tt>GET /projects/foo-bar/edit</tt> requests.
  def edit
    respond_to do |format|
      format.html # edit.html.erb
    end
  end
  
  # Handles <tt>PUT /projects/foo-bar</tt> requests.
  def update
    if @project.update_attributes(params[:project])
      respond_to do |format|
        format.html do
          flash[:notice] = 'Project was saved.'
          redirect_to project_path(@project)
        end
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
      end
    end
  end
  
  # Handles <tt>PUT /projects/foo-bar/close</tt> requests.
  def close
    if @project.close!
      respond_to do |format|
        format.html { flash[:notice] = 'Project was closed.' }
      end
    end
    respond_to do |format|
      format.html { redirect_to project_path(@project) }
    end
  end
  
  # Handles <tt>PUT /projects/foo-bar/reopen</tt> requests.
  def reopen
    if @project.reopen!
      respond_to do |format|
        format.html { flash[:notice] = 'Project was reopened.' }
      end
    end
    respond_to do |format|
      format.html { redirect_to project_path(@project) }
    end
  end
  
  # Handles <tt>DELETE /projects/foo-bar</tt> requests.
  def destroy
    @project.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = 'Project was deleted.'
        redirect_to projects_path
      end
    end
  end
  
private
  
  def find_project
    @project = Project.find_by_slug_or_formatted_id(params[:id])
    @project || false
  end
  
end
