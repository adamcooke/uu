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

  end 
end

class << ActiveRecord::Base
  def concerned_with(*concerns)
    concerns.each do |concern|
      require_dependency "#{name.underscore}/#{concern}"
    end
  end
end
