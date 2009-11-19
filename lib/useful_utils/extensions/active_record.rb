module ActiveRecord
  class Base
    ## Return whether this entry has just been added or not
  
    def just_created?
      return false unless self.respond_to?(:created_at)
      5.minutes.ago < self.created_at
    end
    
    ## Create a dom-usable id
    
    def dom_id
      display_id = new_record? ? "new" : id
      prefix = prefix.nil? ? self.class.name.underscore : "#{prefix}_#{self.class.name.underscore}"
      prefix.gsub!('/', '_')
      "#{prefix}_#{display_id}"
    end
    
    ## Return whether a field is protected or not
    
    def attr_protected?(column)
      self.class.protected_attributes && self.class.protected_attributes.collect.include?(column.to_s)
    end
    
    ## Return whether a field is read only or not
    
    def attr_readonly?(column)
      self.class.readonly_attributes && self.class.readonly_attributes.collect.include?(column.to_s)      
    end
    
    ## Returh whether a field is currently in read only mode

    def read_only?(column)
      !new_record? and attr_readonly?(column)
    end
    
    def self.concerned_with(*concerns)
      concerns.each do |concern|
        require_dependency "#{name.underscore}/#{concern}"
      end
    end
    
    def self.validates_email(*attr_names)
      configuration = {:on => :save}
      configuration.update(attr_names.extract_options!)
      validates_each(attr_names, configuration) do |record, attr_name, value|
        unless value =~ /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,4}\b\z/i
          record.errors.add(attr_name, :invalid, :default => configuration[:message], :value => value) 
        end
      end
    end
    
    ## This allows you to pass a hash to Model#update_attribute for those of us who have a nasty habit of sending a hash to the method.
    ## For example `account.update_attribute(:name => 'blah')` wouldn't usually work but this makes it work like a dream. 
    
    class NoAttribute; end
    
    def update_attribute_with_hash(name, value = NoAttribute)
      if name.is_a?(Hash)
        if name.size == 1
          name, value = name.to_a.flatten
        else
          raise ArgumentError, "Provided hash must only include one pair. Perhaps you want to use #{self.class.to_s}#update_attributes(hash)?"
        end
      elsif value == NoAttribute
        raise ArgumentError, "wrong number of arguments (1 for 2)"
      end
      self.update_attribute_without_hash(name, value)
    end
    alias_method_chain :update_attribute, :hash

  end 
end
