module UsefulUtils
  
  ## The nav selector allows you to provide navigation links which can be activated by calling methods from
  ## either the controller or the action itself.
  ##
  ## For example, you may have a long list of navigation items and at various times some of these items should
  ## be marked as active - let's say you have a navigation item called "Blog" which should be active on all 
  ## blog pages. We can assume that all blog pages will be called from the BlogController and thus, we can add
  ##   active_nav_item(:primary, :blog)
  ## to the top of the controller.
  ##
  ## This supports as many levels of navigation as you wish, as long as the navigation_link matches that of the 
  ## the active_nav_item declaration.

  module NavSelector
    
    module ControllerMethods
    
      ## These methods can be run in a similar way to before_filter within the controller class.
    
      module ClassMethods
      
        ## Set the active navigation item for a given level of navigation.
        ##
        ## class MyController < ApplicationController
        ##   active_nav_item :primary, :home
        ##   active_nav_item :secondary, :my_page, :only => :my_page
        ## end
      
        def active_nav_item(level, item, *args)
          options = args.extract_options!
          before_filter(options) { |i| i.active_nav_item(level, item) }
        end
      
      end
    
      ## These methods can be called within controller methods (actions)
    
      module InstanceMethods
      
        ## Sets the active navigation item for a given level of navigation.
        ## 
        ## def my_page
        ##   set_active_nav_item(:secondary, :my_page)
        ## end
      
        def active_nav_item(level, item)
          @_active_nav_items = Hash.new unless @_active_nav_items
          @_active_nav_items[level.to_sym] = item
        end
      
      end
    
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
    
    end
  
    ## ActionView helpers
  
    module ViewMethods
    
      ## Return the active navigation item for the specified level.
      def active_nav_item_for(level)
        return nil unless @_active_nav_items && @_active_nav_items[level.to_sym]
        @_active_nav_items[level.to_sym]
      end
    
    
      ## Output a link for use with the navigation selector. 
      ##
      ##   navigation_link(:primary, "The Blog", blog_path)
      ##   navigation_link(:primary, "The Blog", blog_path, :key => :blog)
      def navigation_link(type, label, destination = "#", options = {})
        key = options.delete(:key)
        prefix = options.delete(:prefix) || ''
        suffix = options.delete(:suffix) || ''
        key = label.downcase.gsub(' ', "_").to_sym if key.blank?
        options[:class] = "#{options[:class]} active" if active_nav_item_for(type) && active_nav_item_for(type) == key
        link_to(prefix + label + suffix, destination, options)
      end
        
    end
  
  end

end

ActionController::Base.send :include, UsefulUtils::NavSelector::ControllerMethods
ActionView::Base.send :include, UsefulUtils::NavSelector::ViewMethods
