# Patches ActionView::Helpers::PrototypeHelper#submit_to_remote such that the
# generated +input+ element will have a +type+ attribute of +submit+ instead of
# +button+. This is important for facilitating graceful degradation in the
# absence of JavaScript in the client.

# A module that is mixed into ActionView::Helpers::PrototypeHelper.
module SubmitToRemoteWithTypeAttributeOfSubmit
  
  # Returns a button input tag with the element name of +name+ and a value
  # (i.e., display text) of +value+ that will submit form using XMLHttpRequest
  # in the background instead of a regular POST request that reloads the page. 
  # 
  #  # Create a button that submits to the create action.
  #  # 
  #  # Generates: <input name="create_btn"
  #  #                   onclick="new Ajax.Request('/testing/create',
  #  #                                             {asynchronous:true,
  #  #                                              evalScripts:true,
  #  #                                              parameters:Form.serialize(this.form)});
  #  #                            return false;"
  #  #                   type="submit"
  #  #                   value="Create" />
  #  <%= submit_to_remote 'create_btn',
  #                       'Create',
  #                       :url => {:action => 'create'} %>
  #  
  #  # Submit to the remote action update and update the +div+ with _succeed_ or
  #  # _fail_ based on the success or failure of the request.
  #  # 
  #  # Generates: <input name="update_btn"
  #  #                   onclick="new Ajax.Updater({success:'succeed',
  #  #                                              failure:'fail'},
  #  #                                             '/testing/update',
  #  #                                             {asynchronous:true,
  #  #                                              evalScripts:true,
  #  #                                              parameters:Form.serialize(this.form)});
  #  #                            return false;"
  #  #                   type="submit"
  #  #                   value="Update" />
  #  <%= submit_to_remote 'update_btn',
  #                       'Update',
  #                       :url => { :action => 'update' },
  #                       :update => {:success => 'succeed',
  #                                   :failure => 'fail'}
  # 
  # The +options+ parameter is the same as for _form_remote_tag_.
  def submit_to_remote_with_type_attribute_of_submit(name, value, options={})
    options[:with] ||= 'Form.serialize(this.form)'
    
    options[:html] ||= {}
    options[:html][:type]    = 'submit'
    options[:html][:onclick] = "#{remote_function(options)}; return false;"
    options[:html][:name]    = name
    options[:html][:value]   = value
    
    tag :input, options[:html], false
  end
  
end

ActionView::Helpers::PrototypeHelper.module_eval do
  include SubmitToRemoteWithTypeAttributeOfSubmit
  alias_method_chain :submit_to_remote, :type_attribute_of_submit
end
