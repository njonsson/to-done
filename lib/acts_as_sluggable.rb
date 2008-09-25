# Adds an +acts_as_sluggable+ class method to Active Record models.

# Gives models the ability to create user-friendly and search-engine-friendly
# resource URLs that contain meaningful identifiers instead of database keys.
module ActsAsSluggable
  
  # Features acts_as_sluggable.
  module ClassMethods
    
    # Configures an Active Record model to use a slug for a URL instead of a
    # numeric database row ID. A slug is a short identifier, usually textual,
    # that has meaning to the user and that is valid as part of a URL. Slugs are
    # automatically prepared from the value of some other column such as an item
    # name or title.
    # 
    # Here's an example. Given routing configuration of:
    # 
    #  ActionController::Routing::Routes.draw do |map|
    #    map.resources :books
    #  end
    # 
    # Here's what standard 'book' resource URLs look like:
    # 
    #  class Book < ActiveRecord::Base
    #  end
    #  
    #  superb_short_stories = Book.create(:title => 'Interpreter of Maladies',
    #                                     :author => 'Jhumpa Lahiri')
    #  book_path(superb_short_stories) # => '/books/123'
    #  
    #  head_trip = Book.create(:title => "_why's Poignant Guide to Ruby",
    #                          :author => 'Why the Lucky Stiff')
    #  book_path(head_trip) # => '/books/456'
    # 
    # Here's what 'book' resource URLs look like using slugs:
    #  
    #  class Book < ActiveRecord::Base
    #    
    #    # Autogenerate a slug from the book's title.
    #    acts_as_sluggable :title
    #    
    #  end
    #  
    #  superb_short_stories = Book.create(:title => 'Interpreter of Maladies',
    #                                     :author => 'Jhumpa Lahiri')
    #  superb_short_stories.slug       # => 'interpreter-of-maladies'
    #  book_path(superb_short_stories) # => '/books/interpreter-of-maladies'
    #  
    #  head_trip = Book.create(:title => "_why's Poignant Guide to Ruby",
    #                          :author => 'Why the Lucky Stiff')
    #  head_trip.slug # => 'whys-poignant-guide-to-ruby'
    #  book_path(head_trip) # => '/books/whys-poignant-guide-to-ruby'
    def acts_as_sluggable(source_column)
      unless columns.detect { |c| c.name == 'slug' }
        raise "#{name} must have a :slug column"
      end
      column_name = source_column.to_s
      unless columns.detect { |c| c.name == column_name }
        raise ArgumentError, "#{source_column.inspect} is not a column of #{name}"
      end
      
      validate :set_slug
      
      model_name = name.underscore.humanize.downcase
      validates_uniqueness_of :slug, :allow_nil => true,
                                     :message => "prepared from #{column_name} " +
                                                 'conflicts with that of '       +
                                                 "another #{model_name}"
      
      class << self
        define_method(:find_by_slug_or_formatted_id) do |id|
          id = id.to_s
          return find(id.gsub(/^-(\d+)-$/, '\1')) if id =~ /^-\d+-$/
          find_by_slug id
        end
        
        define_method(:reserved_slugs) do
          @reserved_slugs ||= []
        end
      end
      
      define_method(:formatted_id) do
        "-#{id}-"
      end
      
      klass = self
      define_method(:to_param_with_slug) do
        return formatted_id if ['new', *klass.reserved_slugs].include?(slug_was)
        slug_was
      end
      alias_method_chain :to_param, :slug
      
      define_method(:set_slug) do
        return self unless (source = send(source_column))
        self.slug = ActsAsSluggable.text_to_slug(source)
        self
      end
      private :set_slug
    end
    
  end
  
  class << self
    
    # Extends _other_module_ with ClassMethods.
    def included(other_module)
      other_module.extend ClassMethods
    end
    
    # Returns the specified _text_ transformed into a URL-ready slug.
    def text_to_slug(text)
      return nil unless (slug = text.dup)
      substitutions = [[/^[^a-z0-9]+/i,           ''],     # Trim beginning.
                       [/[^a-z0-9]+$/i,           ''],     # Trim end.
                       [/([a-z0-9])'([a-z0-9])/i, '\1\2'], # Delete an
                                                           # apostrophe in a
                                                           # word.
                       [/[^a-z0-9]+/i,            '-']]    # Non-alphanumeric
                                                           # becomes hyphen.
      substitutions.each do |pattern, substitution|
        slug.gsub! pattern, substitution
      end
      slug.downcase
    end
    
  end
  
end

ActiveRecord::Base.class_eval { include ActsAsSluggable }
