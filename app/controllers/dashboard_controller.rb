# Defines DashboardController.

# Handles requests to render dashboard views.
class DashboardController < ApplicationController
  
  # Handles <tt>GET /</tt> requests.
  def index
    @tasks = Project.closed(false).collect do |project|
      project.tasks.finished(false).first
    end.compact
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
end
