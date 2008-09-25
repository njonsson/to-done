# Defines ApplicationHelper.

# Methods added to this helper will be available to all templates in the
# application.
module ApplicationHelper
  
  # Returns the name of the application as displayed in the page body, providing
  # for the capabilities of various user agents to display the pointing-finger
  # glyph.
  def application_name_for_body
    branding_renderer = BrandingRenderer.new(user_agent)
    branding_renderer.application_name_for_body
  end
  
  # Returns the name of the application as displayed in the page title,
  # providing for the capabilities of various user agents to display the
  # pointing-finger glyph.
  def application_name_for_title
    branding_renderer = BrandingRenderer.new(user_agent)
    branding_renderer.application_name_for_title
  end
  
  # Returns the specified button wrapped in an <li> element.
  def button_list_item(name, options, html_options={})
    content_tag :li, button_to(name, options, html_options)
  end
  
  # Returns the specified pointing-finger glyph if the user agent is capable of
  # displaying it. The _direction_ argument must be <tt>:up</tt>,
  # <tt>:right</tt> or <tt>:down</tt>.
  def finger_glyph_for_body(direction)
    branding_renderer = BrandingRenderer.new(user_agent)
    branding_renderer.finger_glyph_for_body direction
  end
  
  # Returns the pointing-finger glyph if the user agent is capable of displaying
  # it.
  def finger_glyph_for_flash
    branding_renderer = BrandingRenderer.new(user_agent)
    branding_renderer.finger_glyph_for_flash
  end
  
  # Returns the specified link wrapped in an <li> element. The element will
  # include a CSS class of _current_ if <tt>current_page? url</tt> returns
  # +true+.
  def link_list_item(name, url, options={})
    append_class_name(options, 'current') if current_page?(url)
    if options.delete(:always_link)
      content_tag :li, link_to(name, url), options
    else
      content_tag :li, link_to_unless_current(name, url), options
    end
  end
  
  def link_to_tasks(count, path, options={})
    singular    = [options[:before], 'task'].compact.join(' ')
    noun_phrase = pluralize_with_pretty_zero(count, singular)
    after       = options[:after]
    text        = [noun_phrase, after].compact.join(' ')
    link_to text, path
  end
  
  # Returns the specified _title_ followed by "(page _x_)" if the specified
  # _collection_ has multiple pages.
  def page_title_with_pagination(title, collection)
    pagination = collection.total_pages > 1 ?
                 " (page #{collection.current_page})" :
                 nil
    "#{title}#{pagination}"
  end
  
  # Attempts to pluralize the +singular+ word unless +count+ is 1. If +plural+
  # is supplied, it will use that when <tt>count > 1</tt>, otherwise it will use
  # the Inflector to determine the plural form.
  # 
  # ==== Examples
  # 
  #  pluralize_with_pretty_zero(1, 'person')
  #  # => '1 person'
  #  
  #  pluralize_with_pretty_zero(2, 'person')
  #  # => '2 people'
  #  
  #  pluralize_with_pretty_zero(3, 'person', 'users')
  #  # => '3 users'
  #  
  #  pluralize_with_pretty_zero(0, 'person')
  #  # => no people
  def pluralize_with_pretty_zero(count, singular, plural=nil)
    "#{count.to_i.zero? ? 'no' : count} " + ((count.to_s == '1') ?
                                             singular :
                                             (plural || singular.pluralize))
  end
  
  # Returns the specified submit button wrapped in an <li> element.
  def submit_list_item(form, value="Save changes", options={})
    content_tag :li, form.submit(value, options)
  end
  
private
  
  def append_class_name(options, class_name)
    options[:class] = (options.fetch(:class, '').split(' ') <<
                       class_name).join(' ')
  end
  
  def user_agent
    request.env['HTTP_USER_AGENT']
  end
  
end
