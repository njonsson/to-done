# Defines SearchNamedScope.

# When mixed into an ActiveRecord model, this module defines on the model a
# named scope called _search_.
module SearchNamedScope
  
  # Adds a named scope called _search_ to _other_module_.
  def self.included(other_module)
    other_module.module_eval do
      named_scope :search, lambda { |*search_terms|
        conditions = {:sql => [], :values => []}
        conditions = search_terms.inject(conditions) do |result, search_term|
          result[:sql] << '(name LIKE ?) OR (notes LIKE ?)'
          result[:values].concat(["%#{search_term}%"] * 2)
          result
        end
        {:conditions => [conditions[:sql].join(' OR '), *conditions[:values]],
         :order => 'name'}
      }
    end
  end
  
end
