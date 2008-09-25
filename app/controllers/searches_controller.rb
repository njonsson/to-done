# Defines SearchesController.

# Handles requests for the Search resource.
class SearchesController < ApplicationController
  
  # Handles <tt>GET /search?q=foo+bar</tt> requests.
  def show
    @search = Search.new(params[:q])
    @search.fetch_results unless params[:q].blank?
    
    respond_to do |format|
      format.html do
        render :layout => ! request.xhr?
      end
    end
  end
  
end
