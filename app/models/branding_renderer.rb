# Defines BrandingRenderer.

# Renders branding elements according to the idiosyncrasies of various browsers
# on various platforms.
class BrandingRenderer
  
  # The User-Agent string supplied by a browser.
  attr_reader :user_agent
  
  # Instantiates a new BrandingRenderer for the specified user agent.
  def initialize(user_agent)
    @user_agent = user_agent
    define_tester_methods
  end
  
  # Returns the name of the application, as it appears on the body of a page,
  # according to the idiosyncrasies of the browser indicated by _user_agent_.
  def application_name_for_body
    return nil unless user_agent
    "To #{finger_glyph_for_body} Done!"
  end
  
  # Returns the name of the application, as it appears in the title of a page,
  # according to the idiosyncrasies of the browser indicated by _user_agent_.
  def application_name_for_title
    return nil unless user_agent
    "To #{finger_glyph_for_title} Done!"
  end
  
  # Returns the specified pointing-finger glyph, as it appears in flash
  # messages, according to the idiosyncrasies of the browser indicated by
  # _user_agent_. The _direction_ argument must be <tt>:up</tt>, <tt>:right</tt>
  # or <tt>:down</tt>.
  def finger_glyph_for_body(direction=:right)
    return nil unless user_agent
    if user_agent.windows?
      if user_agent.internet_explorer? || user_agent.chrome?
        return '<span style="font-family: Wingdings;">'             +
               {:right => 'F', :up => 'G', :down => 'H'}[direction] +
               '</span>'
      end
      return '&' + {:right => 'r', :up => 'u', :down => 'd'}[direction] + 'arr;'
    end
    {:right => '☞', :up => '☝', :down => '☟'}[direction]
  end
  
  # Returns the right-pointing-finger glyph, as it appears in flash messages,
  # according to the idiosyncrasies of the browser indicated by _user_agent_.
  def finger_glyph_for_flash
    return nil unless user_agent
    if user_agent.windows?
      if user_agent.internet_explorer? || user_agent.chrome?
        return '<span style="font-family: Wingdings;">F</span>&nbsp;'
      end
      return nil
    end
    '☞&nbsp;'
  end
  
private
  
  def define_tester_methods
    def user_agent.chrome?
      ! (self =~ /Chrome/).nil?
    end
    
    def user_agent.internet_explorer?
      ! (self =~ /MSIE/).nil?
    end
    
    def user_agent.windows?
      ! (self =~ /Windows/).nil?
    end
  end
  
  def finger_glyph_for_title
    return '&ndash;&rsaquo;' if user_agent.windows?
    '☞'
  end
  
end
