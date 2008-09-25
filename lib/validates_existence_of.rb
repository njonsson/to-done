# Adds a +validates_existence_of+ validation to ActiveRecord models.

# A module that is mixed into ActiveRecord::Base.
module ValidatesExistenceOf
  
  # Validation methods used to extend ActiveRecord::Base.
  module ClassMethods
    
    # Validates that the associated object or objects all exist in the database.
    # Works with +belongs_to+ associations. Happens by default on save.
    # 
    #   class Book < ActiveRecord::Base
    #     
    #     belongs_to :library
    #     
    #     validates_existence_of :library
    #     
    #   end
    # 
    # === Note
    # 
    # This validation will *not* fail if the association hasn't been assigned.
    # If you want to ensure that the association is both present and guaranteed
    # to exist in the database, you also need to use +validates_presence_of+.
    # 
    # === Configuration options
    # 
    # [<tt>:message</tt>] A custom error message (default is: "must be an
    #                     existing %s" where <i>%s</i> is the humanized class
    #                     name).
    # [<tt>:on</tt>] Specifies when this validation is active (default is
    #                <tt>:save</tt>, other options <tt>:create</tt>,
    #                <tt>:update</tt>).
    # [<tt>:if</tt>] Specifies a method, proc or string to call to
    #                determine if the validation should
    #                occur (e.g. <tt>:if => :allow_validation</tt>, or
    #                <tt>:if => Proc.new { |user| user.signup_step > 2 }</tt>).
    #                The method, proc or string should return or evaluate
    #                to +true+ or +false+.
    # [<tt>:unless</tt>] Specifies a method, proc or string to call to determine
    #                    if the validation should not occur (e.g.,
    #                    <tt>:unless => :skip_validation</tt>, or
    #                    <tt>:unless => Proc.new { |user| user.signup_step <= 2 }</tt>).
    #                    The method, proc or string should return or evaluate to
    #                    +true+ or +false+.
    # [<tt>:class_name</tt>] Specifies the class name of the association. Use it
    #                        only if that name can‘t be inferred from the
    #                        association name. So
    #                        <tt>validates_existence_of :author</tt> will by
    #                        default be linked to the Author class, but if the
    #                        real class name is Person, you‘ll have to specify
    #                        it with this option.
    # [<tt>:foreign_key</tt>] Specifies the foreign key used for the
    #                         association. By default this is guessed to be the
    #                         name of the association with an "_id" suffix. So
    #                         <tt>validates_existence_of :person</tt> will by
    #                         default be linked to the +person_id+ foreign_key.
    #                         Similarly,
    #                         <tt>validates_existence_of :favorite_person,
    #                         :class_name => 'Person'</tt> will use a foreign
    #                         key of +favorite_person_id+.
    def validates_existence_of(*attr_names)
      configuration = {:message => ActiveRecord::Errors.default_error_messages[:existence],
                       :on => :save}
      configuration.merge! attr_names.extract_options!
      allow_blank = configuration.delete(:allow_blank)
      allow_nil   = configuration.delete(:allow_nil)
      
      validates_each(attr_names, configuration) do |record, attr, value|
        next if ! value.nil? && value.new_record?
        
        class_name  = configuration[:class_name] || attr.to_s.classify
        foreign_key = configuration[:foreign_key] || class_name.foreign_key
        id = (value && value.id) ? value.id : record.read_attribute(foreign_key)
        next if id.blank? && allow_blank
        next if id.nil?   && allow_nil
        klass = class_name.constantize
        begin
          klass.find id
        rescue ActiveRecord::RecordNotFound
          message = configuration[:message] % class_name.downcase
          record.errors.add attr, message
        end
      end
    end
    
  end
  
  # Extends _other_module_ with ClassMethods.
  def self.included(other_module)
    other_module.extend ClassMethods
  end
  
end

ActiveRecord::Base.class_eval { include ValidatesExistenceOf }
ActiveRecord::Errors.default_error_messages[:existence] = 'must be an existing %s'
