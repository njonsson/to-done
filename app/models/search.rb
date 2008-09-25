# Defines Search.

# Represents a full-text search of the system.
class Search
  
  # Returns an array of matches found by fetch_results.
  attr_reader :results
  
  # Returns an array of search terms contained in the search string.
  attr_reader :search_terms
  
  # Instantiates a new Search for the specified _search_string_.
  def initialize(search_string)
    @search_terms = search_string.split(/\s+/)
    @results = []
  end
  
  # Performs the search, populating results.
  def fetch_results
    @results = []
    fetch_task_results
    fetch_project_results
    @results
  end
  
private
  
  def fetch_project_results
    @results.concat Project.search(*search_terms)
  end
  
  def fetch_task_results
    @results.concat Task.search(*search_terms)
  end
  
end
